within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D;
model SinglePhase_Developed_2Region_Simple
  "Single Phase | Fully Developed | 2 Region - Laminar & Turbulent | Simple Method"
  import TRANSFORM;

  extends PartialSinglePhase;

  input Units.nonDim[nFM] fRe2=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_SinglePhase_2Region(
        Res,
        dimensionsAvg,
        roughnessesAvg,
        Re_center,
        Re_width) "Turbulent Friction factor"
    annotation (Dialog(group="Input Variables"));

  SI.Pressure[nFM] dps_f "Frictional pressure drop";
  SI.Pressure[nFM] dps_g "Gravitational pressure drop";

protected
  SI.DynamicViscosity mus[nFM];
  SI.DynamicViscosity mus_a[nFM]=mediaProps[1:nFM].mu;
  SI.DynamicViscosity mus_b[nFM]=mediaProps[2:nFM + 1].mu;
  SI.Density ds[nFM];
  SI.Density ds_a[nFM]=mediaProps[1:nFM].d;
  SI.Density ds_b[nFM]=mediaProps[2:nFM + 1].d;
  SI.Length dimensionsAvg[nFM];
  SI.Length roughnessesAvg[nFM];

equation

  dps_fg = dps_f+dps_g;

  for i in 1:nFM loop
    dps_f[i] = 0.5*fRe2[i]*dlengths[i]*mus[i]^2/(dimensionsAvg[i]*dimensionsAvg[
      i]*dimensionsAvg[i]*ds[i])*noEvent(if m_flows[i] >= 0 then +1 else -1);

    dps_g[i] = g_n*dheights[i]*0.5*(Medium.density(states[i]) + Medium.density(
      states[i + 1]));
  end for;

  for i in 1:nFM loop
    dimensionsAvg[i] = 0.5*(dimensions[i] + dimensions[i + 1]);
    roughnessesAvg[i] = 0.5*(roughnesses[i] + roughnesses[i + 1]);
    ds[i] = TRANSFORM.Math.spliceTanh(
      ds_a[i],
      ds_b[i],
      m_flows[i],
      m_flow_small);
    mus[i] = TRANSFORM.Math.spliceTanh(
      mus_a[i],
      mus_b[i],
      m_flows[i],
      m_flow_small);
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SinglePhase_Developed_2Region_Simple;
