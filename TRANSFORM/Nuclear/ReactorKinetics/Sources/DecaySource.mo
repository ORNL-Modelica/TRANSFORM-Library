within TRANSFORM.Nuclear.ReactorKinetics.Sources;
model DecaySource "Generate a rising and falling exponential signal"

  extends Modelica.Blocks.Interfaces.SO;
  extends Modelica.Icons.UnderConstruction;

  //parameter Real outMax=1 "Height of output for infinite riseTime";
  //parameter SI.Time riseTime(min=0, start=0.5) "Rise time";
  //parameter Real offset=0 "Offset of output signal";
  //parameter SI.Time startTime=0
    //"Output = offset for time < startTime";
  //extends Modelica.Blocks.Interfaces.SO;

  parameter SI.Conversions.NonSIunits.Time_day Operation_Days = 365
    "Operation time before shutdown";
  parameter SI.Power Power_Initial=10E6 "offset, Power(MWt) before shutdown";
  parameter SI.Time startTime=10 "Output = offset for time < startTime";

  SI.Time Operation_Time=SI.Conversions.from_day(Operation_Days) "by sec";
  //Real y_riseTime;

equation
  //y_riseTime = outMax*(1 - Modelica.Math.exp(-riseTime/riseTimeConst));

  //Empirical decay equation is very sensitive to time, so add 0.00001 to start time to avoid power inconsistence at t=tstart
  y = (if (time <= startTime+0.00001) then Power_Initial else Power_Initial * 0.066 * ( (time - startTime)^(-0.2) - (time - startTime+Operation_Time)^(-0.2)));

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-90,-70},{68,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-77.2,-55.3},{-74.3,-42.1},{-70.8,-27.6},{-67.3,
              -15},{-63.7,-4.08},{-59.5,7.18},{-55.3,16.7},{-50.3,26},{-44.6,
              34.5},{-38.3,42.1},{-31.2,48.6},{-22.7,54.3},{-12.1,59.2},{-10,
              60},{-7.88,47.5},{-5.05,32.7},{-2.22,19.8},{0.606,8.45},{4.14,-3.7},
              {7.68,-14},{11.9,-24.2},{16.2,-32.6},{21.1,-40.5},{26.8,-47.4},
              {33.1,-53.3},{40.9,-58.5},{50.8,-62.8},{60,-65.4}}, color={0,0,
              0}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="StartTime=%startTime")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-90,-74},{84,-74}}, color={95,95,95}),
        Polygon(
          points={{97,-74},{81,-70},{81,-78},{97,-74}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,-34},{-37.2,-19.3},{-34.3,-6.1},{-30.8,8.4},{-27.3,
              21},{-23.7,31.92},{-19.5,43.18},{-15.3,52.7},{-10.3,62},{-4.6,
              70.5},{1.7,78.1},{8.8,84.6},{17.3,90.3},{27.9,95.2},{30,96},{
              32.12,83.5},{34.95,68.7},{37.78,55.8},{40.606,44.45},{44.14,
              32.3},{47.68,22},{51.9,11.8},{56.2,3.4},{61.1,-4.5},{66.8,
              -11.4},{73.1,-17.3},{80.9,-22.5},{90.8,-26.8},{100,-29.4}},
          color={0,0,255},
          thickness=0.5),
        Polygon(
          points={{-80,86},{-86,64},{-74,64},{-80,86}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,64},{-80,-84}}, color={95,95,95}),
        Text(
          extent={{-81,87},{-40,67}},
          lineColor={95,95,95},
          textString="y"),
        Text(
          extent={{-71,-46},{-38,-55}},
          lineColor={0,0,0},
          textString="offset"),
        Polygon(
          points={{-40,-74},{-42,-64},{-38,-64},{-40,-74},{-40,-74}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,-34},{-40,-74}}, color={95,95,95}),
        Polygon(
          points={{-40,-34},{-42,-44},{-38,-44},{-40,-34}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-39,-34},{-80,-34}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-62,-76},{-17,-85}},
          lineColor={0,0,0},
          textString="startTime"),
        Polygon(
          points={{-40,-34},{-31,-32},{-31,-36},{-40,-34}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,-34},{30,-34}}, color={95,95,95}),
        Polygon(
          points={{30,-34},{22,-32},{22,-36},{30,-34}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-26,-22},{19,-32}},
          lineColor={0,0,0},
          textString="riseTime"),
        Text(
          extent={{75,-79},{98,-90}},
          lineColor={0,0,0},
          textString="time"),
        Line(points={{30,96},{30,-38}}, color={95,95,95})}),
    Documentation(info="<html>
<p>
The Real output y is a rising exponential followed
by a falling exponential signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Exponentials.png\"
     alt=\"Exponentials.png\">
</p>
</html>"));
end DecaySource;
