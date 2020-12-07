within TRANSFORM.Blocks;
block TimerTotal
  "Timer measuring total time that the Boolean input is true"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;
  Modelica.Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  discrete Modelica.Units.SI.Time entryTime "Time instant when u became true";
  discrete Modelica.Units.SI.Time y_last "y output instant when u became false";
initial equation
  pre(entryTime) = 0;
  pre(y) = 0;
equation
  when u then
    entryTime = time;
  end when;
  when not u then
    y_last = pre(y);
  end when;
  y = if u then time - entryTime + y_last else y_last;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Line(points={{-90.0,-70.0},{82.0,-70.0}},
        color={192,192,192}),
      Line(points={{-80.0,68.0},{-80.0,-80.0}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
      Line(points={{-80,-70},{-60,-70},{-60,-26},{-30,-26},{-30,-70},{0,-70},{0,
              -26},{30,-26},{30,-70},{66,-70}},
        color={255,0,255}),
      Line(points={{-80,0},{-62,0},{-30,30},{0,30},{30,64},{68,64}},
        color={0,0,127})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>When the Boolean input &QUOT;u&QUOT; becomes <b>true</b>, the timer is started and the output &QUOT;y&QUOT; is the time from the time instant where u became true.</p>
<p>When the timer is stopped the output retains its value and then continues when &QUOT;u&QUOT; becomes true again.</p>
<p>This enables a measurement of the total time the input was true over the simulation.</p>
</html>"));
end TimerTotal;
