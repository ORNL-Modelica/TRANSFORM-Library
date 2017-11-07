within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses;
partial model PartialPipeFlowHeatTransfer
  "Base class for pipe heat transfer correlation in terms of Nusselt number heat transfer in a circular pipe for laminar and turbulent one-phase flow"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialFlowHeatTransfer(
      alphas_start=100*ones(nHT));

  Real[nHT] Res "Reynolds numbers";
  Real[nHT] Prs "Prandtl numbers";
  Real[nHT] Nus "Nusselt numbers";
  Medium.Density[nHT] ds "Densities";
  Medium.DynamicViscosity[nHT] mus "Dynamic viscosities";
  Medium.ThermalConductivity[nHT] lambdas "Thermal conductivity";

equation
  ds=Medium.density(states);
  mus=Medium.dynamicViscosity(states);
  lambdas=Medium.thermalConductivity(states);
  Prs = Medium.prandtlNumber(states);
  Res = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flows,
    mu=mus,
    D=dimensions,
    A=crossAreas);

  Q_flows={alphas[i]*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:nHT};

    annotation (Documentation(info="<html>
<p>
Base class for heat transfer models that are expressed in terms of the Nusselt number and which can be used in distributed pipe models.
</p>
</html>"));
end PartialPipeFlowHeatTransfer;
