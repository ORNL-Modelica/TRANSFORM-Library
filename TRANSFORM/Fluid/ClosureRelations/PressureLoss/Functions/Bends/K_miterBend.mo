within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Bends;
function K_miterBend
  "Pipe Bend | Single-joint mitered (sharp) bend | Rennels"
  // Source: Rennels, D. C. & Hudson, H. M. Pipe Flow: A Practical and Comprehensive Guide. (Wiley, 2012).
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.bend_miter(method="Rennels").
  // K is referenced to the pipe velocity head. Valid for deflection angles up to ~150 deg.
  extends TRANSFORM.Icons.Function;
  input SI.Angle angle "Bend deflection (turning) angle";
  output Units.NonDim K "Resistance coefficient";
protected
  Real s=sin(0.5*angle) "sin(angle/2)";
algorithm
  K := 0.42*s + 2.56*s^3;
  annotation (smoothOrder=2, Documentation(info="<html>
<p>Resistance coefficient for a single-joint <b>mitered (sharp) pipe bend</b> per Rennels &amp; Hudson (2012):</p>
<blockquote><code>K = 0.42 sin(&alpha;/2) + 2.56 sin&sup3;(&alpha;/2)</code></blockquote>
<p>referenced to the pipe velocity head, valid for deflection angles up to about 150&deg;. A mitered bend has no
curvature radius (the pipe simply changes direction at a sharp joint), so it is considerably more lossy than a smooth
bend of the same angle (<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Bends.K_smoothBend\">K_smoothBend</a>).
Multi-segment miters (two or three joints) have lower loss; ignoring that is common, slightly conservative practice.
Validated against Rennels: <code>K_miterBend(150&deg;) = 2.713</code>.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
</html>"));
end K_miterBend;
