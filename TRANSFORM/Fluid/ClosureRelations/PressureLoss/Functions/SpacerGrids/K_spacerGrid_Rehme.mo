within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.SpacerGrids;
function K_spacerGrid_Rehme
  "Rod bundle spacer grid | Rehme modified drag-coefficient method | referenced to bundle velocity"
  // Source: Rehme, K. Pressure Drop Correlations for Fuel Element Spacers. Nuclear Technology 17 (1973) 15-23.
  //   K = Cv*epsilon^2, referenced to the undisturbed bundle velocity head.
  // Drag-coefficient equation (semi-empirical fit of Rehme's Cv chart):
  //   Cigarini & Dalle Donne (1988); Schikorr, Bubelis, Mansani & Litfin, Nucl. Eng. Des. 240 (2010) 1830-1842.
  extends TRANSFORM.Icons.Function;
  input Units.NonDim epsilon "Blockage ratio = spacer frontal (projected) area / bundle flow area";
  input SI.ReynoldsNumber Re "Bundle Reynolds number";
  output Units.NonDim K "Resistance coefficient (ref. bundle velocity head)";
protected
  SI.ReynoldsNumber Re_int=max(Re, 1.0) "Guarded Reynolds number";
  Units.NonDim Cv_eq=3.5 + 73.14/Re_int^0.264 + 2.79e10/Re_int^2.79
    "Schikorr-Bubelis modified drag coefficient";
  Units.NonDim Cv=min(Cv_eq, 2.0/epsilon) "Drag coefficient (capped at 2/epsilon)";
algorithm
  K := Cv*epsilon^2;
  annotation (Documentation(info="<html>
<p>Spacer-grid pressure-loss coefficient for a rod bundle by the <b>Rehme (1973) modified drag-coefficient method</b>:</p>
<blockquote><code>K = C<sub>v</sub>&middot;&epsilon;&sup2;</code>,&nbsp; referenced to the undisturbed bundle velocity head
(<code>dp = K&middot;m_flow&sup2;/(2&rho;A_bundle&sup2;)</code>)</blockquote>
<p>where <code>&epsilon;</code> is the blockage ratio (spacer projected frontal area / bundle flow area, valid ~0.15&ndash;0.5)
and <code>C<sub>v</sub></code> is the modified drag coefficient. Rehme gives <code>C<sub>v</sub></code> as a chart vs
Reynolds number; here the semi-empirical fit of that chart (Cigarini &amp; Dalle Donne 1988; Schikorr et&nbsp;al. 2010) is
used:</p>
<blockquote><code>C<sub>v</sub> = 3.5 + 73.14/Re^0.264 + 2.79&times;10&sup1;&#8304;/Re^2.79</code>, capped at <code>2/&epsilon;</code></blockquote>
<p>(e.g. <code>C<sub>v</sub>&asymp;10</code> at Re=10&#8308;, <code>&asymp;5.8</code> at Re=5&times;10&#8309;).</p>
<h4>References</h4>
<p>Rehme, K. <i>Pressure Drop Correlations for Fuel Element Spacers</i>, Nuclear Technology <b>17</b> (1973) 15&ndash;23.</p>
<p>Schikorr, M., Bubelis, E., Mansani, L. &amp; Litfin, K. <i>Proposal for pressure drop prediction for a fuel bundle with
grid spacers using Rehme pressure drop correlations</i>, Nucl. Eng. Des. <b>240</b> (2010) 1830&ndash;1842.</p>
</html>"));
end K_spacerGrid_Rehme;
