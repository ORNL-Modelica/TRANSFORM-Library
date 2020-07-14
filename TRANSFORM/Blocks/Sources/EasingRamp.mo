within TRANSFORM.Blocks.Sources;
block EasingRamp "Generate ramp signal"
  parameter Real height=1 "Height of ramps"
    annotation(Dialog(groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png"));
  parameter Modelica.SIunits.Time duration(min=0.0, start=2)
    "Duration of ramp (= 0.0 gives a Step)";
  extends Modelica.Blocks.Interfaces.SignalSource;

  parameter Real deltax=0.1;
  parameter Real f = 1.0;

  Real y_ramp;
  //Real dy_easeIn;
  //Real dy_easeOut;

  Real y_easeIn;
  Real y_easeOut;


equation



  y_easeIn = TRANSFORM.Math.Easing.Cubic.easeIn(
    pos=y_ramp,
    neg=0,
    x=time - startTime,
    deltax=deltax);
  //dy_easeIn = der(y_easeIn);

  y_easeOut = TRANSFORM.Math.Easing.Cubic.easeOut(
    pos=height,
    neg=y_ramp,
    x=time - (startTime+duration),
    deltax=deltax);
  //dy_easeOut = der(y_easeOut);

  y_ramp = (if time < startTime then 0 else if time < (startTime +
    duration) then (time - startTime)*height/duration*f else height);

  y = offset + (if time < startTime+deltax then y_easeIn else if time > startTime+duration-deltax then y_easeOut else y_ramp);

  dy = (if time < startTime then 0 else if time > startTime+duration then 0 else y_ramp);
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
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="duration=%duration"),
        Line(points={{31,38},{86,38}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,-20},{-20,-20},{50,50}},
          color={0,0,255},
          thickness=0.5),
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
          points={{-19,-20},{50,-20}},
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
          textString="duration")}),
    Documentation(info="<html>
<p>
The Real output y is a ramp signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png\"
     alt=\"Ramp.png\">
</p>

<p>
If parameter duration is set to 0.0, the limiting case of a Step signal is achieved.
</p>
</html>"));
end EasingRamp;
