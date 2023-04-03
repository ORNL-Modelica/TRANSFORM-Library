within TRANSFORM.Utilities.Visualizers.Outputs;
model Bar
  extends TRANSFORM.Utilities.Visualizers.BaseClasses.Scaling;

  parameter Boolean hideConnector=false;

  input Real input_Value=fromConnector annotation (Dialog(enable=hideConnector));
  Modelica.Blocks.Interfaces.RealInput Value if not hideConnector annotation (Placement(
        iconTransformation(extent={{-120,-10},{-100,10}}),transformation(extent={{-140,
            -20},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=input_Value) if hideConnector
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Real y=internalNode;
protected
  constant Real fromConnector=0 "Dummy introduced to get nice dialogs";
  Modelica.Blocks.Interfaces.RealOutput internalNode
                                            annotation(Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{90,-10},{110,
            10}}, rotation=0)));
equation
  connect(Value, internalNode)
                    annotation (Line(
      points={{-120,0},{70,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, internalNode)
                               annotation (Line(
      points={{1,-30},{20,-30},{20,0},{70,0}},
      color={0,0,127},
      smooth=Smooth.None));
  scaled = internalNode;
  annotation (__Dymola_structurallyIncomplete,Icon(coordinateSystem(
            preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{0,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=[0,-100; 100,DynamicSelect(0, min(max(unScaled, 0), 1)*200
               - 100)],
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,70},{0,130}},
          lineColor={0,0,255},
          textString="%max"),
        Text(
          extent={{-100,-130},{0,-70}},
          lineColor={0,0,255},
          textString="%min")}));
end Bar;
