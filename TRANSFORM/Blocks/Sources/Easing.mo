within TRANSFORM.Blocks.Sources;
model Easing

  replaceable function Easing = TRANSFORM.Math.Easing.Sine.easeInOut
    constrainedby TRANSFORM.Math.Easing.PartialEasing         "Transition function" annotation (
      choicesAllMatching=true, Documentation(info="<html>
</html>"));

  parameter Real pos "Returned value after transition";
  parameter Real neg "Returned value before transition";
  parameter SI.Time dt=1
    "Region around transition time (+/-dt) with spline interpolationt";

  extends Modelica.Blocks.Interfaces.SignalSource;

equation

  y = Easing(
    pos=pos,
    neg=neg,
    x=time - startTime - dt,
    deltax=dt) + offset;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-20},{-16,-20},{4,60},{62,60}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/easing.jpg\"/></p>
</html>"));
end Easing;
