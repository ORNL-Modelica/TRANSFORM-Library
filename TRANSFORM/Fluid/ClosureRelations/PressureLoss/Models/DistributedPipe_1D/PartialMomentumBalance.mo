within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D;
partial model PartialMomentumBalance

  import Modelica.Fluid.Types.Dynamics;

  extends PartialDistributedStaggeredFlow;

  input Units.NonDim Ks_ab[nFM]=fill(0, nFM)
    "Minor loss coefficients. Flow in direction a -> b"
    annotation (Dialog(group="Input Variables"));
  input Units.NonDim Ks_ba[nFM]=fill(0, nFM)
    "Minor loss coefficients. Flow in direction b -> a"
    annotation (Dialog(group="Input Variables"));
//   input SI.PressureDifference dps_add_ab[nFM]=fill(0, nFM)
//     "Additional pressure losses. Flow in direction a -> b"
//     annotation (Dialog(group="Input Variables"));
//   input SI.PressureDifference dps_add_ba[nFM]=fill(0, nFM)
//     "Additional pressure losses. Flow in direction b -> a"
//     annotation (Dialog(group="Input Variables"));

  parameter Boolean use_I_flows=momentumDynamics <> Dynamics.SteadyState
    "= true to consider differences in flow of momentum through boundaries"
    annotation (Dialog(tab="Advanced"), Evaluate=true);

  parameter SI.Time taus[2]={0.01,0.01} "Time Constant for first order delay of {dps_K,dps_add}"
    annotation (Dialog(tab="Advanced"));

  // Source terms and forces to be defined by an extending model (zero if not used)
  SI.Force[nFM] I_flows "Flow of momentum across boundaries";
  SI.Force[nFM] Fs_p "Pressure forces";
  SI.Force[nFM] Fs_fg "Friction and gravity forces";

  SI.Pressure[nFM] dps_fg(start=dps_start) "Pressure drop between states";
  SI.PressureDifference dps_K[nFM] "Minor form-losses (K-loss)";
//   SI.PressureDifference dps_add[nFM] "Minor additional pressure losses";

  Modelica.Blocks.Continuous.FirstOrder firstOrder_dps_K[nFM](
    each initType=Modelica.Blocks.Types.Init.InitialOutput,
    each y_start=0,
    each T=taus[1]) annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
//   Modelica.Blocks.Continuous.FirstOrder firstOrder_dps_add[nFM](
//     each initType=Modelica.Blocks.Types.Init.InitialOutput,
//     each y_start=0,
//     each T=taus[2])
//     annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation

  Ibs = I_flows - Fs_p - Fs_fg;

  if use_I_flows then
    I_flows = {crossAreas[i]*Medium.density(states[i])*vs[i]*vs[i] - crossAreas[
      i + 1]*Medium.density(states[i + 1])*vs[i + 1]*vs[i + 1] for i in 1:nFM};
  else
    I_flows = zeros(nFM);
  end if;

  Fs_p = {0.5*(crossAreas[i] + crossAreas[i + 1])*(Medium.pressure(states[i+1]) -
    Medium.pressure(states[i])) for i in 1:nFM};

  Fs_fg = {(dps_fg[i] + firstOrder_dps_K[i].y)*0.5*(crossAreas[i] + crossAreas[i + 1]) for i in 1:nFM};

   dps_K = {noEvent(if m_flows[i] > 0 then 0.5*Ks_ab[i]*Medium.density(states[i])*vs[i]*vs[i] else
          - 0.5*Ks_ba[i]*Medium.density(states[i + 1])*vs[i + 1]*vs[i + 1]) for i in 1:nFM};

//    dps_add = {noEvent(if m_flows[i] > 0 then dps_add_ab[i] else dps_add_ba[i]) for i in 1:nFM};

   firstOrder_dps_K[:].u = dps_K;
//    firstOrder_dps_add[:].u = dps_add;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMomentumBalance;
