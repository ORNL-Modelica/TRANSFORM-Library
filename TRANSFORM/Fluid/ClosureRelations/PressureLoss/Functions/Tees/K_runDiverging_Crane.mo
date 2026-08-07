within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees;
function K_runDiverging_Crane
  "Tee/Wye | Dividing flow | Run (straight) loss coefficient | Crane TP-410"
  // Source: Crane Co. Flow of Fluids Through Valves, Fittings, and Pipe (TP-410), 2009/2013.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.K_run_diverging_Crane.
  // K is referenced to the velocity head of the COMBINED (run-inlet) flow.
  extends TRANSFORM.Icons.Function;
  input SI.Length D_run "Run (combined) pipe diameter";
  input SI.Length D_branch "Branch pipe diameter";
  input SI.VolumeFlowRate V_run "Volumetric flow in the run/straight leg (magnitude)";
  input SI.VolumeFlowRate V_branch "Volumetric flow in the branch leg (magnitude)";
  input SI.Angle angle "Angle between branch and run (unused; included for a uniform interface)";
  output Units.NonDim K "Resistance coefficient";
protected
  Real beta=D_branch/D_run "Diameter ratio";
  Real beta2=beta*beta;
  SI.VolumeFlowRate Q_comb=V_run + V_branch "Combined flow";
  Real Qr=V_branch/max(Q_comb, Modelica.Constants.eps) "Branch-to-combined flow ratio";
  Real M;
algorithm
  if beta2 <= 0.4 then
    M := 0.4;
  elseif Qr <= 0.5 then
    M := 2.0*(2.0*Qr - 1.0);
  else
    M := 0.3*(2.0*Qr - 1.0);
  end if;
  K := M*Qr*Qr;
  annotation (Documentation(info="<html>
<p>Run (straight-through) loss coefficient for a <b>dividing-flow</b> tee or wye (Crane TP-410), referenced to the
combined (run-inlet) velocity head: <code>K_run = M&middot;Qr&sup2;</code>, with <code>M</code> a piecewise function of the
diameter ratio and flow ratio <code>Qr = Q_branch/Q_comb</code>. Can be slightly negative (pressure recovery in the run).
Validated against Crane Example 7-36 (<code>K_runDiverging_Crane(0.146,0.146,0.02525,0.01583,45&deg;) = -0.0681</code>).</p>
<h4>References</h4>
<p>Crane Co. <i>Flow of Fluids Through Valves, Fittings, and Pipe</i> (Technical Paper No. 410), 2009.</p>
</html>"));
end K_runDiverging_Crane;
