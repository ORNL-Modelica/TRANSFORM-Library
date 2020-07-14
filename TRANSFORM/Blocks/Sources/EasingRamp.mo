within TRANSFORM.Blocks.Sources;
block EasingRamp "Generate ramp signal with smooth curves in/out of ramp"
  parameter Real height=1 "Height of ramps" annotation (Dialog(groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png"));
  parameter Modelica.SIunits.Time duration(
    min=0.0,
    start=2) "Duration of ramp (= 0.0 gives a Step)";
  extends Modelica.Blocks.Interfaces.SignalSource;

  parameter Real curvature(min=0.0,max=1.0)=0.5;

protected
  final parameter Real xi(fixed=false, start=0.5*radius);
  final parameter Real m(fixed=false, start=height/duration);

  final parameter Real b(fixed=false, start=0);
  final parameter Real radius(fixed=false);

initial equation

  // This bounding was determined by setting the circle equation y(x=d/2)=h/2 and solving for r for h<=d. h>d was found by inspection
  if height > duration then
    radius = curvature*0.5*duration;
  else
    radius = curvature*0.25*(duration^2/height + height);
  end if;

  if radius < Modelica.Constants.eps then
    m = height/duration;
    xi = 0;
    b = 0;
  else
    // BC 1 | dy1/dx(x=xi) = dy2/dx(x=xi)
    m = xi/sqrt(radius^2 - xi^2);

    // BC 2 | y1(x=xi) = y2(x=xi)
    m*xi + b = -sqrt(radius^2 - xi^2) + radius;

    // BC 3 | y1(x=duration/2) = height/2
    0.5*height = m*0.5*duration + b;
  end if;

equation

  if radius < Modelica.Constants.eps then
    // Identical to Modelica.Blocks.Sources.Ramp
    y = offset + (if time < startTime then 0 else if time < (startTime +
      duration) then (time - startTime)*height/duration else height);

  else
    y = offset + (if time <= startTime then 0 elseif time <= startTime + xi
       then -sqrt(radius^2 - (time - startTime)^2) + radius elseif time <=
      startTime + duration - xi then m*(time - startTime) + b elseif time <=
      startTime + duration then sqrt(radius^2 - (time - startTime - duration)^2)
       + (height - radius) else height);
  end if;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="duration=%duration"),
        Line(points={{31,38},{86,38}}),
        Line(
          points={{-40,-70},{-22,-70},{-14,-46}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{32,38},{12,38},{6,16}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{6,16},{-14,-46}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(points={{-81,-70},{-40,-70}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-64},{68,-76},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-20},{-42,-30},{-38,-30},{-40,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,-20},{-40,-70}},
          color={95,95,95}),
        Polygon(
          points={{-40,-70},{-42,-60},{-38,-60},{-40,-70},{-40,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-39},{-34,-50}},
          textString="offset"),
        Text(
          extent={{-38,-72},{6,-83}},
          textString="startTime"),
        Text(
          extent={{-78,92},{-37,72}},
          textString="y"),
        Text(
          extent={{70,-80},{94,-91}},
          textString="time"),
        Line(points={{-20,-20},{-20,-70}}, color={95,95,95}),
        Line(
          points={{-17,-20},{52,-20}},
          color={95,95,95}),
        Line(
          points={{50,50},{101,50}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{50,50},{50,-20}},
          color={95,95,95}),
        Polygon(
          points={{50,-20},{42,-18},{42,-22},{50,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-20},{-11,-18},{-11,-22},{-20,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,50},{48,40},{52,40},{50,50}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-20},{48,-10},{52,-10},{50,-20},{50,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{53,23},{82,10}},
          textString="height"),
        Text(
          extent={{-2,-21},{37,-33}},
          textString="duration"),
        Line(
          points={{-20,-20},{-2,-20},{6,-6}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(points={{0,20}}, color={28,108,200}),
        Line(
          points={{26,36},{34,50},{50,50}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,-6},{26,36}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-80,-20},{-20,-20}},
          color={0,0,255},
          thickness=0.5)}),
    Documentation(info="<html>
<p>The Real output y is a ramp signal with circular easing into and out of the ramp: </p>
<p><img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png\" alt=\"Ramp.png\"/> </p>
<p>If parameter duration is set to 0.0, the limiting case of a Step signal is achieved. </p>
<p>If curvature is set to 0.0 then the exact behavior of Modelica.Blocks.Sources.Ramp is achieved.</p>
<p>If curvature is set to 1.0 then the there is circular easing into and out of the change in height with no linear ramp.</p>
</html>"));
end EasingRamp;
