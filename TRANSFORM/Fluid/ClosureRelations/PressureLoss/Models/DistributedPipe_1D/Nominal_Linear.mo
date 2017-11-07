within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D;
model Nominal_Linear "Set nominal dp and m_flow"

  extends PartialSinglePhase;

  parameter SI.AbsolutePressure dp_nominal=1 "Nominal pressure loss across pipe";
  parameter SI.MassFlowRate m_flow_nominal=1 "Mass flow rate for dp_nominal";

  SI.Pressure[nFM] dps_f "Frictional pressure drop";
  SI.Pressure[nFM] dps_g "Gravitational pressure drop";

equation

  dps_fg = dps_f + dps_g;

  for i in 1:nFM loop
    dps_f[i] =dp_nominal/m_flow_nominal/nFM*m_flows[i];
    dps_g[i] =g_n*dheights[i]*0.5*(Medium.density(states[i]) + Medium.density(
      states[i + 1]));
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nominal_Linear;
