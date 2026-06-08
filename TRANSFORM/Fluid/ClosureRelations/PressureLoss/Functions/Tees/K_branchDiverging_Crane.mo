within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees;
function K_branchDiverging_Crane
  "Tee/Wye | Dividing flow | Branch loss coefficient | Crane TP-410"
  // Source: Crane Co. Flow of Fluids Through Valves, Fittings, and Pipe (TP-410), 2009/2013.
  // Cross-check: Bell, C. "fluids" library, fluids.fittings.K_branch_diverging_Crane.
  // K is referenced to the velocity head of the COMBINED (run-inlet) flow.
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
  Real H;
  Real J;
  Real G;
  constant SI.Angle deg60=60*Modelica.Constants.pi/180;
  constant SI.Angle deg75=75*Modelica.Constants.pi/180;
algorithm
  // H, J selection (90 deg, beta=1 tee vs wye)
  if angle < deg60 or beta <= 2.0/3.0 then
    H := 1.0;
    J := 2.0;
  else
    H := 0.3;
    J := 0.0;
  end if;
  // G selection. The 75 deg split bridges the gap between wye (<60) and tee (90) behavior.
  if angle < deg75 then
    if beta2 <= 0.35 then
      G := if Qr <= 0.4 then 1.1 - 0.7*Qr else 0.85;
    else
      G := if Qr <= 0.6 then 1.0 - 0.6*Qr else 0.6;
    end if;
  else
    if beta2 <= 2.0/3.0 then
      G := 1.0;
    else
      G := 1.0 + 0.3*Qr*Qr;
    end if;
  end if;
  K := G*(1.0 + H*(Qr/beta2)^2 - J*(Qr/beta2)*cos(angle));
  annotation (Documentation(info="<html>
<p>Branch loss coefficient for a <b>dividing-flow</b> tee or wye (Crane TP-410), referenced to the velocity head of the
combined (run-inlet) flow:</p>
<blockquote><code>K_branch = G[1 + H(Qr/&beta;&sup2;)&sup2; - J(Qr/&beta;&sup2;)cos&theta;]</code></blockquote>
<p>where <code>Qr = Q_branch/Q_comb</code>, <code>&beta; = D_branch/D_run</code> and <code>&theta;</code> is the branch
angle. The explicit <code>cos&theta;</code> term captures the take-off-angle dependence (a 45&deg; wye is less lossy than
a 90&deg; tee). Validated against Crane Example 7-36
(<code>K_branchDiverging_Crane(0.146,0.146,0.02525,0.01583,45&deg;) = 0.464</code>).</p>
<h4>References</h4>
<p>Crane Co. <i>Flow of Fluids Through Valves, Fittings, and Pipe</i> (Technical Paper No. 410), 2009.</p>
</html>"));
end K_branchDiverging_Crane;
