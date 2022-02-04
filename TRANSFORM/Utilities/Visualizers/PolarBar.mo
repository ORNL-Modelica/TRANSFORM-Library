within TRANSFORM.Utilities.Visualizers;
model PolarBar "Kind of like UserInteraction.Outputs.Bar but polar"
  extends UserInteraction.Internal.Scaling;

  parameter Boolean hideConnector=false;

  input Real input_Value=fromConnector annotation (Dialog(enable=hideConnector));
  Modelica.Blocks.Interfaces.RealInput Value if not hideConnector annotation (Placement(
        iconTransformation(extent={{120,-10},{100,10}}),  transformation(extent={{140,-20},
            {100,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=input_Value) if hideConnector
    annotation (Placement(transformation(extent={{58,-40},{38,-20}})));
  Real y=internalNode;
  Modelica.Blocks.Tables.CombiTable1Ds position(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=table,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "input: angle, output: position"
    annotation (Placement(transformation(extent={{-34,16},{-54,36}})));
  parameter Real table[:,:]=[0,0; 1,Modelica.Constants.pi]
    "Table matrix (grid = first column; e.g., table=[0, 0; 1, 1; 2, 4])";
protected
  constant Real fromConnector=0 "Dummy introduced to get nice dialogs";
  Modelica.Blocks.Interfaces.RealOutput internalNode
                                            annotation(Placement(transformation(
          extent={{56,-18},{36,2}}),  iconTransformation(extent={{90,-10},{110,
            10}}, rotation=0)));

equation
  connect(Value, internalNode)
                    annotation (Line(
      points={{120,0},{88,0},{88,-8},{46,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, internalNode)
                               annotation (Line(
      points={{37,-30},{2,-30},{2,-8},{46,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  scaled = internalNode;
  connect(position.u, Value)
    annotation (Line(points={{-32,26},{-32,0},{120,0}},   color={0,0,127}));
  annotation (__Dymola_structurallyIncomplete,Icon(coordinateSystem(
            preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-160,8},{-60,68}},
          lineColor={0,0,255},
          textString="%max"),
        Text(
          extent={{62,8},{162,68}},
          lineColor={0,0,255},
          textString="%min"),
        Polygon(points=[0,0;
                        DynamicSelect(80,100*cos(position.y[1]-0.6435)),DynamicSelect(-60,100*sin(position.y[1]-0.6435));
                        DynamicSelect(80,100*cos(position.y[1]+0.6435)),DynamicSelect(60,100*sin(position.y[1]+0.6435));
                        0,0],
                        lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end PolarBar;
