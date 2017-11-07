within TRANSFORM.Icons;
model DummyIcon

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-34,32},{34,-32}},
          fillPattern=FillPattern.Solid,
          fillColor={221,221,0},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-30,28},{0,0}},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,28},{30,0}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,0},{30,-28}},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,0},{0,-28}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end DummyIcon;
