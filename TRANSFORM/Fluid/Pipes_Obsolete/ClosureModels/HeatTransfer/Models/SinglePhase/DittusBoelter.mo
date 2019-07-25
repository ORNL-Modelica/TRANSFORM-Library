within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase;
model DittusBoelter
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;
  SI.NusseltNumber[nHT] Nus "Nusselt number";
  SI.ReynoldsNumber[nHT] Res "Reynolds number";
  SI.PrandtlNumber[nHT] Prs "Prandtl number";
equation
  Prs = Medium.prandtlNumber(states);
  Res = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flows_single,
    mu=mediums1.mu,
    D=dimensions,
    A=crossAreas);
  for i in 1:nHT loop
    alphas[i] =
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter(
              D=dimensions[i],
              lambda=mediums1[i].lambda,
              Re=Res[i],
              Pr=Prs[i]);
  end for;
  Nus = Utilities.CharacteristicNumbers.NusseltNumber(alphas, dimensions,mediums1.lambda);
  annotation (defaultComponentName="heatTransfer",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DittusBoelter;
