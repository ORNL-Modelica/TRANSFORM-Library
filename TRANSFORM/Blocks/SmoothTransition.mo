within TRANSFORM.Blocks;
model SmoothTransition

  extends Modelica.Blocks.Interfaces.SI2SO;

  parameter Real deltax=1 "Region around x with spline interpolation";

  Modelica.Blocks.Interfaces.RealInput x annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
equation

  y = Math.spliceTanh(u1, u2, x, deltax);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{2,28},{2,-20}}, color={192,192,192}),
        Line(points={{-80,58},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,80},{-88,58},{-72,58},{-80,80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-74,50},{-48,24}},
          lineColor={0,0,0},
          textString="u1"),
        Text(
          extent={{54,46},{80,20}},
          lineColor={238,46,47},
          textString="y"),
        Line(points={{-60,28},{60,28}},
                                      color={0,0,0}),
        Line(
          points={{-60,-20},{-8,-20},{2,2},{12,28},{60,28}},
          color={255,0,0},
          smooth=Smooth.Bezier),
        Line(points={{-60,-20},{60,-20}},
                                      color={0,0,0}),
        Text(
          extent={{-74,-18},{-48,-44}},
          lineColor={0,0,0},
          textString="u2"),
        Text(
          extent={{-4,-18},{10,-34}},
          lineColor={0,0,0},
          textString="x")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Provides a smooth transition between u1 and u2 using spliceTanh function.</p>
<p><span style=\"font-family: Courier New;\">  u1 &quot;Returned value for x-deltax &gt;= 0&quot;;</span></p>
<p><span style=\"font-family: Courier New;\">  u2 &quot;Returned value for x+deltax &lt;= 0&quot;;</span></p>
</html>"));
end SmoothTransition;
