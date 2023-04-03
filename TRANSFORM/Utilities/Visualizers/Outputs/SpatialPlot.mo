within TRANSFORM.Utilities.Visualizers.Outputs;
model SpatialPlot "Polyline with coordinate system"
  input Real x[:]={1} "Horizontal values for curve" annotation (Dialog);
  input Real y[size(x, 1)]={1} "Vertical values for curve" annotation (Dialog);
  parameter Real minX=0;
  parameter Real maxX=1;
  parameter Real minY=0;
  parameter Real maxY=1;
  parameter TRANSFORM.Utilities.Visualizers.BaseClasses.Color color={255,0,0} "Color (RGB) of curve";

  TRANSFORM.Utilities.Visualizers.Outputs.PolyLine PolyLine1(
    x=x,
    y=y,
    minX=minX,
    maxX=maxX,
    minY=minY,
    maxY=maxY,
    color=color) annotation (__Dymola_layer="icon", Placement(transformation(extent={{-80,-80},{80,80}}, rotation=0)));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,255}),
        Text(
          extent={{-100,76},{-74,84}},
          lineColor={0,0,255},
          textString="%maxY"),
        Text(
          extent={{-100,-84},{-74,-76}},
          lineColor={0,0,255},
          textString="%minY"),
        Text(
          extent={{-94,-94},{-64,-86}},
          lineColor={0,0,255},
          textString="%minX"),
        Text(
          extent={{66,-94},{96,-86}},
          lineColor={0,0,255},
          textString="%maxX")}));
end SpatialPlot;
