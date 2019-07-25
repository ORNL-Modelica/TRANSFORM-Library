within TRANSFORM.Blocks;
model ExponentialDecay "Generate a exponential decay signal"
  parameter SI.DecayConstant lambda=1 "Decay constant";
  parameter Real offset=0 "Offset of output signal";
  parameter Real frac = 0 "Fraction of offset for y(inf)";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;
equation
  //y = offset*(if time < startTime then 1 else Modelica.Math.exp(-lambda*(time-startTime)));
  //y = shift + (offset-shift)*(if time < startTime then 1 else Modelica.Math.exp(-lambda*(time-startTime)));
  //y = frac*offset + (1-frac)*offset*(if time < startTime then 1 else Modelica.Math.exp(-lambda*(time-startTime)));
  y = offset*(frac + (1-frac)*(if time < startTime then 1 else Modelica.Math.exp(-lambda*(time-startTime))));
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
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Line(
          points={{-60,58},{-56,16},{-48,-16},{-28,-34},{10,-36},{56,-36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-60,58},{-80,58}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-36},{60,-36}},
          color={175,175,175},
          smooth=Smooth.Bezier)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>The Real output y is an exponetial decay signal</p>
</html>"));
end ExponentialDecay;
