within TRANSFORM.Icons;
partial class ReleaseNotes
  "Icon for release notes in documentation"

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{-80,-100},{-80,100},{0,100},{0,20},{80,20},{80,-100},{-80,
              -100}},
          lineColor={0,0,0},
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,100},{80,20},{0,20},{0,100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{2,-12},{50,-12}}),
        Ellipse(
          extent={{-56,2},{-28,-26}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{2,-60},{50,-60}}),
        Ellipse(
          extent={{-56,-46},{-28,-74}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates release notes and the revision history of a library.</p>
</html>"));

end ReleaseNotes;
