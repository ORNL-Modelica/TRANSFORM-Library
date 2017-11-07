within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase.LiquidMetal.TubeBundle;
model modifiedSchad
  "modifiedSchad: Liquid metal rod bundle; 1.05 <= P/D <= 1.15, Pe <= 1000"

  /* source: 
  AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov
  Fast Spectrum Reactors 2012
  eq. 9.36ab pg. 258

  1.05 <= P/D <= 1.15
  Pe <= 1000
  */

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;

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
    if Pes[i] <= 150 then
      Nus[i] = 4.496*(-16.15 + 24.96*PDratio - 8.55*PDratio^2);
    else
      Nus[i] = 4.496*(-16.15 + 24.96*PDratio - 8.55*PDratio^2)*(Pes[i]/150)^0.3;
    end if;
    alphas[i] =TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
      Nu=Nus[i],
      D=dimensions[i],
      lambda=mediums1[i].lambda);
  end for;
  annotation (Documentation(info="<html>
<p>The modified Schad is a liquid metal rod bundle heat transfer correlation.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">AlanE.&nbsp;Waltar,&nbsp;Donald&nbsp;R.&nbsp;Todd,&nbsp;Pavel&nbsp;V.&nbsp;Tsvetkov</p>
<p style=\"margin-left: 30px;\">Fast&nbsp;Spectrum&nbsp;Reactors&nbsp;2012</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;9.36ab&nbsp;pg.&nbsp;258</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>1.05 &LT;= Pitch/Diameter &LT;= 1.15</li>
<li>Peclet Number &LT;= 1000</li>
</ul>
</html>"));
end modifiedSchad;
