within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase.LiquidMetal.TubeBundle;
model GraberRieger
  "Graber-Rieger: Liquid metal rod bundle; 1.25 <= P/D <= 1.95, 150 <= Pe <= 3000"
  /* source: 
  AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov
  Fast Spectrum Reactors 2012
  eq. 9.34 pg. 257

  1.25 <= P/D <= 1.95
  150 <= Pe <= 3000
  */
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;
  parameter Real PDratio "Tube Pitch to Diameter ratio" annotation(Dialog(group="Heat Transfer Model:"));
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
    Nus[i] = 0.25 + 6.2*PDratio + (0.32*PDratio - 0.007)*Pes[i]^(0.8-0.024*PDratio);
    alphas[i] =TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
      Nu=Nus[i],
      D=dimensions[i],
      lambda=mediums1[i].lambda);
  end for;
  annotation (Documentation(info="<html>
<p>The Graber-Rieger is a liquid metal rod bundle heat transfer correlation.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">AlanE.&nbsp;Waltar,&nbsp;Donald&nbsp;R.&nbsp;Todd,&nbsp;Pavel&nbsp;V.&nbsp;Tsvetkov</p>
<p style=\"margin-left: 30px;\">Fast&nbsp;Spectrum&nbsp;Reactors&nbsp;2012</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;9.34&nbsp;pg.&nbsp;257</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>1.25 &LT;= Pitch/Diameter &LT;= 1.95</li>
<li>150 &LT;= Peclet Number &LT;= 3000</li>
</ul>
</html>"));
end GraberRieger;
