within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices;
function K_thinOrifice
  "Orifice | Thin sharp-edged orifice / perforated plate | Turbulent | referenced to full-pipe velocity"
  // Source: Idelčik, I. E. Handbook of Hydraulic Resistance. (Begell House). Sharp-edged orifice / perforated plate.
  // K is referenced to the velocity head in the full (upstream) pipe cross-section.
  extends TRANSFORM.Icons.Function;
  input Real ar(min=0, max=1) "Free-area ratio = open area / full pipe area";
  output Units.NonDim K "Resistance coefficient";
protected
  Real a=max(ar, 1e-6) "Guarded free-area ratio";
algorithm
  K := (1.0 + 0.707*sqrt(1.0 - a) - a)^2/a^2;
  annotation (smoothOrder=1, Documentation(info="<html>
<p>Resistance coefficient for a <b>thin sharp-edged orifice</b> (single bore) or a <b>perforated plate</b> (use the total
open-area ratio) in a straight pipe, per Idelchik:</p>
<blockquote><code>K = [1 + 0.707&middot;&radic;(1 - a) - a]&sup2; / a&sup2;</code></blockquote>
<p>where <code>a</code> is the free-area ratio (open area / full pipe area), and <code>K</code> is referenced to the
velocity head in the <b>full pipe</b> cross-section, i.e. used as <code>dp = K&middot;m_flow&sup2;/(2&rho;A_pipe&sup2;)</code>.
The form encodes the vena-contracta contraction followed by sudden expansion; e.g. <code>a=0.5 &rarr; K&asymp;4.0</code>,
<code>a=0.2 &rarr; K&asymp;51</code> (orifices are very lossy at small openings). For a thick (long-bore) orifice an
additional bore-friction term would apply; this function is the thin-plate limit.</p>
<h4>References</h4>
<p>Idelchik, I. E. <i>Handbook of Hydraulic Resistance</i>, Begell House.</p>
</html>"));
end K_thinOrifice;
