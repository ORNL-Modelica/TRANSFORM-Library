within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees;
function K_runConverging_Crane
  "Tee/Wye | Combining flow | Run (straight) loss coefficient | Crane TP-410"
  // Source: Crane Co. Flow of Fluids Through Valves, Fittings, and Pipe (TP-410), 2009/2013.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.K_run_converging_Crane.
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
  constant SI.Angle deg75=75*Modelica.Constants.pi/180;
algorithm
  if angle >= deg75 then
    // Special case for ~90 deg tees
    K := 1.55*Qr - Qr*Qr;
  else
    C := 1.0;
    F := Modelica.Math.Vectors.interpolate(
      {30.0,45.0,60.0},
      {1.74,1.41,1.0},
      a_deg);
    K := C*(1.0 - (1.0 - Qr)^2 - F/beta2*Qr^2);
  end if;
  annotation (Documentation(info="<html>
<p>Run (straight-through) loss coefficient for a <b>combining-flow</b> tee or wye (Crane TP-410), referenced to the
combined (run-outlet) velocity head. For wyes (&lt;75&deg;) <code>K = 1 - (1-Qr)&sup2; - (F/&beta;&sup2;)Qr&sup2;</code> with
<code>F</code> interpolated (30&deg;&rarr;1.74, 45&deg;&rarr;1.41, 60&deg;&rarr;1.0); for ~90&deg; tees the special form
<code>K = 1.55&middot;Qr - Qr&sup2;</code> is used. Validated against Crane Example 7-35
(<code>K_runConverging_Crane(0.1023,0.1023,0.018917,0.00633,90&deg;) = 0.3258</code>).</p>
<h4>References</h4>
<p>Crane Co. <i>Flow of Fluids Through Valves, Fittings, and Pipe</i> (Technical Paper No. 410), 2009.</p>
</html>"));
end K_runConverging_Crane;
