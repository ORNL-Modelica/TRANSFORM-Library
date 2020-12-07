within TRANSFORM.Blocks;
model OffTimer_DerivativeInformed
  "Records the time since the input changed to false considering the slope of the signal"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Boolean positiveDerivative(fixed=true) = true
    "Specify direction upon when trigger is reset";

  Modelica.Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput s
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
protected
  discrete Modelica.Units.SI.Time entryTime "Time instant when u became true";
initial equation
  pre(entryTime) = time;
equation

  if positiveDerivative then
    when (not u and der(s) > 0) then
      entryTime = time;
    end when;
  else
    when (not u and der(s) < 0) then
      entryTime = time;
    end when;
  end if;

  y = time - entryTime;

  annotation (
    Icon(graphics={
        Line(points={{-78,16},{-60,30},{-60,-8},{42,82},{42,-8},{72,18}}, color=
             {0,0,255}),
        Polygon(
          points={{92,-78},{70,-70},{70,-86},{92,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-78},{84,-78}}, color={192,192,192}),
        Line(points={{-78,60},{-78,-88}}, color={192,192,192}),
        Polygon(
          points={{-78,82},{-86,60},{-70,60},{-78,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,-34},{-58,-34},{-58,-78},{-28,-78},{-28,-34},{40,-34},
              {40,-78},{68,-78}}, color={255,0,255})}),
    defaultComponentName="offTim",
    Documentation(info="<html>
<p>
Timer that starts at the initial time with a value of <i>0</i>,
and gets reset each time the input signal switches to <code>false</code>.
</p>
<p>
For example, if the simulation starts at <i>t = 10</i> and at <i>t=11</i>,
the input becomes <code>false</code>, then the timer outputs
<i>y=t-10</i> for <i>t &lt; 11</i>, and <i>y=t-11</i> afterwards, unless
the input becomes false again.
</p>
</html>", revisions="<html>
<p>Modified from IBPSA Library</p>
</html>"));
end OffTimer_DerivativeInformed;
