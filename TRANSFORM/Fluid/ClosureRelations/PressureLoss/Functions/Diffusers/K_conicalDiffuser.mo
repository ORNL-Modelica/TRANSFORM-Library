within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Diffusers;
function K_conicalDiffuser
  "Gradual Expansion | Conical diffuser (small -> large area) | Local + friction loss"
  // Source: Rennels, D. C. & Hudson, H. M. Pipe Flow: A Practical and Comprehensive Guide. (Wiley, 2012). Conical diffuser.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.diffuser_conical(method="Rennels").
  // The coefficient is referenced to the velocity head in the SMALLER (inlet) cross-section.
  // 'angle' is the TOTAL included cone (divergence) angle: angle = 180 deg is the sudden-expansion (Borda-Carnot) limit.
  extends TRANSFORM.Icons.Function;
  input SI.Area crossAreas[2]={0.25,1.0}
    "Cross-sectional areas (order does not matter)";
  input SI.ReynoldsNumber Re "Reynolds number (referenced to the smaller section)";
  input SI.Angle angle "Total included cone (divergence) angle";
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
  SI.Length dmin=sqrt(4*Amin/Modelica.Constants.pi) "Smaller-section diameter";
  Real a_deg=angle*180.0/Modelica.Constants.pi "Total cone angle [deg]";
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
  Units.NonDim Kfr=f*(1.0 - beta4)/(8.0*sin(a_half)) "Arc-friction term";
algorithm
  // Rennels (2012) gradual-expansion correlation, piecewise in the total cone angle.
  // Branches are continuous in value at the 20 deg / 60 deg breakpoints and at beta = 0.5.
  if a_deg <= 20.0 then
    K := 8.30*tan(a_half)^1.75*(1.0 - beta2)^2 + Kfr;
  elseif a_deg <= 60.0 then
    if beta < 0.5 then
      K := (1.366*sqrt(sin(2*Modelica.Constants.pi*(a_deg - 15.0)/180.0)) -
        0.170 - 3.28*(0.0625 - beta4)*sqrt((a_deg - 20.0)/40.0))*(1.0 - beta2)^2
         + Kfr;
    else
      K := (1.366*sqrt(sin(2*Modelica.Constants.pi*(a_deg - 15.0)/180.0)) -
        0.170)*(1.0 - beta2)^2 + Kfr;
    end if;
  else
    if beta < 0.5 then
      K := (1.205 - 3.28*(0.0625 - beta4) - 12.8*beta2^3*sqrt((a_deg - 60.0)/
        120.0))*(1.0 - beta2)^2;
    else
      K := (1.205 - 0.20*sqrt((a_deg - 60.0)/120.0))*(1.0 - beta2)^2;
    end if;
  end if;
  annotation (smoothOrder=1, Documentation(info="<html>
<p>Resistance coefficient <code>K</code> for a gradual expansion (conical diffuser) per Rennels &amp; Hudson (2012),
referenced to the velocity head in the smaller (inlet) cross-section, i.e. used as
<code>dp = K*m_flow^2/(2*rho*min(A)^2)</code>.</p>
<p>The input <code>angle</code> is the <b>total included cone (divergence) angle</b>. The correlation is piecewise in
this angle and the diameter ratio <code>beta = d_small/d_large</code>; the pieces are constructed to be continuous
in value across the 20&deg;/60&deg; breakpoints and across <code>beta = 0.5</code>. At <code>angle = 180&deg;</code>
the correlation reduces to the Borda-Carnot sudden-expansion limit <code>K = (1 - beta^2)^2</code>.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
</html>"));
end K_conicalDiffuser;
