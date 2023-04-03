within TRANSFORM.Utilities.Visualizers.Outputs;
model SpatialPlot2 "Two polylines with coordinate systems"
  input Real x1[:]={1} "Horizontal values for first curve" annotation (Dialog);
  input Real y1[size(x1, 1)]={1} "Vertical values for first curve"
    annotation (Dialog);
  input Real x2[:]=x1 "Horizontal values for second curve" annotation (Dialog);
  input Real y2[size(x2, 1)] "Vertical values for second curve"
    annotation (Dialog);
  parameter Real minX1=0;
  parameter Real maxX1=1;
  parameter Real minY1=0;
  parameter Real maxY1=1;
  parameter Real minX2=minX1;
  parameter Real maxX2=maxX1;
  parameter Real minY2=minY1;
  parameter Real maxY2=maxY1;
  parameter TRANSFORM.Utilities.Visualizers.BaseClasses.Color color1={255,0,0} "Color (RGB) of first curve" annotation (__Dymola_Hide=false);
  parameter TRANSFORM.Utilities.Visualizers.BaseClasses.Color color2={0,0,255} "Color (RGB) of second curve" annotation (__Dymola_Hide=false);

  TRANSFORM.Utilities.Visualizers.Outputs.PolyLine PolyLine1(
    x=x1,
    y=y1,
    minX=minX1,
    maxX=maxX1,
    minY=minY1,
    maxY=maxY1,
    color=color1) annotation (__Dymola_layer="icon", Placement(transformation(extent={{-80,-80},{80,80}}, rotation=0)));
  TRANSFORM.Utilities.Visualizers.Outputs.PolyLine PolyLine2(
    x=x2,
    y=y2,
    minX=minX2,
    maxX=maxX2,
    minY=minY2,
    maxY=maxY2,
    color=color2) annotation (__Dymola_layer="icon", Placement(transformation(extent={{-80,-80},{80,80}}, rotation=0)));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,255}),
        Text(
          extent={{-92,-92},{-64,-84}},
          lineColor={0,0,255},
          textString="%minX1"),
        Text(
          extent={{66,-92},{96,-84}},
          lineColor={0,0,255},
          textString="%maxX1"),
        Text(
          extent={{-92,-100},{-64,-92}},
          lineColor={0,0,255},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="%minX2"),
        Text(
          extent={{66,-100},{96,-92}},
          lineColor={0,0,255},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="%maxX2"),
        Text(
          extent={{-100,-84},{-74,-76}},
          lineColor={0,0,255},
          textString="%minY1"),
        Text(
          extent={{-100,76},{-74,84}},
          lineColor={0,0,255},
          textString="%maxY1"),
        Text(
          extent={{76,-84},{102,-76}},
          lineColor={0,0,255},
          textString="%minY2"),
        Text(
          extent={{76,76},{102,84}},
          lineColor={0,0,255},
          textString="%maxY2"),
        Line(points={{-80,-80},{-80,80}}, color={0,0,255}),
        Line(points={{80,-80},{80,80}}, color={0,0,255})}));

end SpatialPlot2;
