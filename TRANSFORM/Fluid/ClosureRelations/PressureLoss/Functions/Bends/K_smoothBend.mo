within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Bends;
function K_smoothBend
  "Pipe Bend | Smooth circular bend/elbow | Laminar, Transition, and Turbulent | Local + arc-friction loss"
  // Source: Rennels, D. C. & Hudson, H. M. Pipe Flow: A Practical and Comprehensive Guide. (Wiley, 2012). Eq. for smooth pipe bends.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.bend_rounded(method="Rennels").
  // The coefficient is referenced to the velocity head in the (constant) pipe cross-section.
  extends TRANSFORM.Icons.Function;
  input SI.Length dimension "Pipe (hydraulic) diameter";
  input SI.Length radius "Bend radius of curvature (to the pipe centerline)";
  input SI.Angle angle "Bend deflection (turning) angle";
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.Length roughness=0 "Average height of surface asperities";
  input SI.ReynoldsNumber Re_lam=2300 "Laminar transition Reynolds number";
  input SI.ReynoldsNumber Re_turb=4000 "Turbulent transition Reynolds number";
  output Units.NonDim K "Resistance coefficient";
protected
  Real rcd=radius/dimension "Relative bend radius rc/D";
  SI.Angle a_half=0.5*angle "Half of the deflection angle";
  SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb) "Re smoothing transition center";
  SI.ReynoldsNumber Re_width=Re_turb - 0.5*(Re_lam + Re_turb) "Re smoothing transition width";
  Units.NonDim fRe2=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_SinglePhase_2Region(
      Re,
      dimension,
      roughness,
      Re_center,
      Re_width) "Darcy friction factor*Re^2";
  Units.NonDim f=fRe2/max(Re, 1.0)^2 "Darcy friction factor (Re floored at 1)";
algorithm
  // Rennels (2012): K = f*(angle)*(rc/D) [arc friction]
  //               + (0.10 + 2.4*f)*sin(angle/2) [primary turning loss]
  //               + 6.6*f*(sqrt(sin(angle/2)) + sin(angle/2))/(rc/D)^(4*angle/pi) [secondary-flow loss]
  K := f*angle*rcd + (0.10 + 2.4*f)*sin(a_half) + 6.6*f*(sqrt(sin(a_half)) +
    sin(a_half))/rcd^(4*angle/Modelica.Constants.pi);
  annotation (smoothOrder=1, Documentation(info="<html>
<p>Resistance coefficient <code>K</code> for a smooth circular pipe bend (elbow) per Rennels &amp; Hudson (2012).
The coefficient is referenced to the velocity head in the pipe cross-section (constant diameter through the bend),
i.e. it is used as <code>dp = K*m_flow^2/(2*rho*A^2)</code> with <code>A</code> the pipe cross-sectional area.</p>
<p>The correlation combines an arc-friction term, the primary turning loss, and a secondary-flow (Dean-vortex) term.
It reduces toward the straight-pipe friction loss as the deflection angle approaches zero and is valid for
arbitrary turning angle and relative bend radius <code>rc/D</code>.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
</html>"));
end K_smoothBend;
