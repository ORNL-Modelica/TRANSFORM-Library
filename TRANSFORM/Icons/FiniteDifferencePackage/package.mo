within TRANSFORM.Icons;
partial package FiniteDifferencePackage
  extends Icons.Package;

  annotation (Icon(graphics={
      Text(
        extent={{-12,-4},{12,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j"),
      Ellipse(
        extent={{4,4},{-4,-4}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Ellipse(
        extent={{64,4},{56,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-56,4},{-64,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,64},{-4,56}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,-56},{-4,-64}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Text(
        extent={{42,-4},{82,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i+1, j"),
      Text(
        extent={{-18,58},{18,40}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j+1"),
      Text(
        extent={{-18,-62},{18,-80}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j-1"),
      Text(
        extent={{-78,-4},{-38,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i-1, j"),
        Polygon(
          points={{-84,78},{-92,56},{-76,56},{-84,78}},
          lineColor={192,192,192},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-84,56},{-84,-82}}, color={0,0,0}),
        Line(points={{-84,-82},{78,-82}}, color={0,0,0}),
        Polygon(
          points={{86,-82},{64,-74},{64,-90},{86,-82}},
          lineColor={192,192,192},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end FiniteDifferencePackage;
