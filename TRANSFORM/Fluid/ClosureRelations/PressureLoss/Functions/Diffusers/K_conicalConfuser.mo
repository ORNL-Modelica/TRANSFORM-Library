within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Diffusers;
function K_conicalConfuser
  "Gradual Contraction | Conical confuser/nozzle (large -> small area) | Local + friction loss"
  // Source: Rennels, D. C. & Hudson, H. M. Pipe Flow: A Practical and Comprehensive Guide. (Wiley, 2012). Conical contraction.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.contraction_conical(method="Rennels").
  // The coefficient is referenced to the velocity head in the SMALLER (outlet) cross-section.
  // 'angle' is the TOTAL included cone (convergence) angle.
  extends TRANSFORM.Icons.Function;
  input SI.Area crossAreas[2]={1.0,0.25}
    "Cross-sectional areas (order does not matter)";
  input SI.ReynoldsNumber Re "Reynolds number (referenced to the smaller section)";
  input SI.Angle angle "Total included cone (convergence) angle";
  input SI.Length roughness=0 "Average height of surface asperities";
  input SI.ReynoldsNumber Re_lam=2300 "Laminar transition Reynolds number";
  input SI.ReynoldsNumber Re_turb=4000 "Turbulent transition Reynolds number";
  output Units.NonDim K "Resistance coefficient";
protected
  SI.Area Amin=min(crossAreas) "Smaller cross-sectional area";
  SI.Area Amax=max(crossAreas) "Larger cross-sectional area";
  Real beta=sqrt(Amin/Amax) "Diameter ratio d_small/d_large (<=1)";
  Real beta2=beta*beta;
  Real beta4=beta2*beta2;
  Real beta5=beta4*beta;
  SI.Length dmin=sqrt(4*Amin/Modelica.Constants.pi) "Smaller-section diameter";
  SI.Angle a_half=0.5*angle "Half of the cone angle";
  SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb);
  SI.ReynoldsNumber Re_width=Re_turb - 0.5*(Re_lam + Re_turb);
  Units.NonDim fRe2=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_SinglePhase_2Region(
      Re,
      dmin,
      roughness,
      Re_center,
      Re_width);
  Units.NonDim f=fRe2/max(Re, 1.0)^2 "Darcy friction factor (Re floored at 1)";
  Real lambda=1.0 + 0.622*(angle/Modelica.Constants.pi)^0.8*(1.0 - 0.215*beta2
       - 0.785*beta5) "Convergence parameter";
  Units.NonDim Kfr=f*(1.0 - beta4)/(8.0*sin(a_half)) "Friction term";
  Units.NonDim Kconv=0.0696*sin(a_half)*(1.0 - beta5)*lambda^2 + (lambda - 1.0)
      ^2 "Convective term";
algorithm
  K := Kfr + Kconv;
  annotation (smoothOrder=1, Documentation(info="<html>
<p>Resistance coefficient <code>K</code> for a gradual contraction (conical confuser / nozzle) per
Rennels &amp; Hudson (2012), referenced to the velocity head in the smaller (outlet) cross-section, i.e. used as
<code>dp = K*m_flow^2/(2*rho*min(A)^2)</code>.</p>
<p>The input <code>angle</code> is the <b>total included cone (convergence) angle</b>. The loss is the sum of a
friction term and a convective term that grows with the convergence parameter <code>lambda</code>.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
</html>"));
end K_conicalConfuser;
