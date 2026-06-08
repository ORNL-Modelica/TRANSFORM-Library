within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees;
function K_branchConverging_Crane
  "Tee/Wye | Combining flow | Branch loss coefficient | Crane TP-410"
  // Source: Crane Co. Flow of Fluids Through Valves, Fittings, and Pipe (TP-410), 2009/2013.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.K_branch_converging_Crane.
  // K is referenced to the velocity head of the COMBINED (run-outlet) flow.
  extends TRANSFORM.Icons.Function;
  input SI.Length D_run "Run (combined) pipe diameter";
  input SI.Length D_branch "Branch pipe diameter";
  input SI.VolumeFlowRate V_run "Volumetric flow in the run/straight leg (magnitude)";
  input SI.VolumeFlowRate V_branch "Volumetric flow in the branch leg (magnitude)";
  input SI.Angle angle "Angle between branch and run (tee=90 deg, wye<90 deg)";
  output Units.NonDim K "Resistance coefficient";
protected
  Real beta=D_branch/D_run "Diameter ratio";
  Real beta2=beta*beta;
  SI.VolumeFlowRate Q_comb=V_run + V_branch "Combined flow";
  Real Qr=V_branch/max(Q_comb, Modelica.Constants.eps) "Branch-to-combined flow ratio";
  Real C;
  Real F;
  Real a_deg=angle*180.0/Modelica.Constants.pi;
algorithm
  if beta2 <= 0.35 then
    C := 1.0;
  elseif Qr <= 0.4 then
    C := 0.9*(1.0 - Qr);
  else
    C := 0.55;
  end if;
  // F linearly interpolated vs branch angle [deg]
  F := Modelica.Math.Vectors.interpolate(
    {30.0,45.0,60.0,90.0},
    {1.74,1.41,1.0,0.0},
    a_deg);
  K := C*(1.0 + (Qr/beta2)^2 - 2.0*(1.0 - Qr)^2 - F/beta2*Qr^2);
  annotation (Documentation(info="<html>
<p>Branch loss coefficient for a <b>combining-flow</b> tee or wye (Crane TP-410), referenced to the combined (run-outlet)
velocity head. The branch-angle dependence enters through <code>F</code> (linearly interpolated: 30&deg;&rarr;1.74,
45&deg;&rarr;1.41, 60&deg;&rarr;1.0, 90&deg;&rarr;0). Can be negative. Validated against Crane Example 7-35
(<code>K_branchConverging_Crane(0.1023,0.1023,0.018917,0.00633,90&deg;) = -0.0404</code>).</p>
<h4>References</h4>
<p>Crane Co. <i>Flow of Fluids Through Valves, Fittings, and Pipe</i> (Technical Paper No. 410), 2009.</p>
</html>"));
end K_branchConverging_Crane;
