within TRANSFORM.Examples.Interfaces;
expandable connector SignalSubBus "Icon for signal sub-bus"

  annotation (defaultComponentName="sensorSubBus",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}, initialScale=0.2), graphics={
          Rectangle(
            lineColor={255,215,136},
            lineThickness=0.5,
            pattern=LinePattern.Dash,
            extent={{-20.0,-2.0},{20.0,2.0}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
            smooth=Smooth.Bezier,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-55,15},{-45,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{45,15},{55,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,-25},{5,-15}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.2), graphics={
        Polygon(
          points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
          lineColor={0,0,0},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{-22.5,7.5},{-17.5,12.5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{17.5,12.5},{22.5,7.5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2.5,-7.5},{2.5,-12.5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,70},{150,40}},
          lineColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
This icon is designed for a <b>signal bus</b> connector.
</html>"));
end SignalSubBus;
