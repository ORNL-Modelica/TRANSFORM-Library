within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase.LiquidMetal.CircularTube;
model LyonMartinelli
  "Lyon-Martinelli: Liquid metal correlation for flow in circular tubes and constant heat flux"
  /* source: 
  M. M. Wakil
  Nuclear Heat Transport 1993
  eq. 10-2 pg. 268
  
  Valid for:
  - liquid metal coolant
  - flow in circular tubes
  - constant heat flux along tube wall
  */
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;
  SI.NusseltNumber[nHT] Nus "Nusselt number";
  SI.ReynoldsNumber[nHT] Res "Reynolds number";
  SI.PrandtlNumber[nHT] Prs "Prandtl number";
  Real[nHT] Pes "Peclet Number";
equation
  Prs = Medium.prandtlNumber(states);
  Res = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flows/nParallel,
    mu=mediums1.mu,
    D=dimensions,
    A=crossAreas);
  Pes = TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Res, Prs);
  for i in 1:nHT loop
    Nus[i] = 7 + 0.025*Pes[i]^0.8;
    alphas[i] =TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
      Nu=Nus[i],
      D=dimensions[i],
      lambda=mediums1[i].lambda);
  end for;
  annotation (Documentation(info="<html>
<p>The Lyon-Martinelli heat transfer correlation is for flow of liquid metal in circular tubes with contant heat flux along the tube wall.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">M.&nbsp;M.&nbsp;Wakil</p>
<p style=\"margin-left: 30px;\">Nuclear&nbsp;Heat&nbsp;Transport&nbsp;1993</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;10-2&nbsp;pg.&nbsp;268</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>flow in circular tubes</li>
<li>constant heat flux along tube wall</li>
</ul>
</html>"));
end LyonMartinelli;
