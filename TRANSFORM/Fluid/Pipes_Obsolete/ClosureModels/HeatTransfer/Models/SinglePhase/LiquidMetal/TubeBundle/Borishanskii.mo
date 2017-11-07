within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase.LiquidMetal.TubeBundle;
model Borishanskii
  "Borishanskii et al.: Liquid metal rod bundle; 1.1 <= P/D <= 1.5, Pe <= 2000"

  /* source: 
  AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov
  Fast Spectrum Reactors 2012
  eq. 9.33ab pg. 257

  1.1 <= P/D <= 1.5
  Pe <= 2000
  */

  import Modelica.Math.log10;
  import Modelica.Math.exp;

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
    if Pes[i] <= 200 then
      Nus[i] = 24.15*log10(-8.12 + 12.76*PDratio - 3.65*PDratio^2);
    else
      Nus[i] = 24.15*log10(-8.12 + 12.76*PDratio - 3.65*PDratio^2)
               + 0.0174*(1-exp(-6*(PDratio-1)))*(Pes[i]-200)^0.9;
    end if;
    alphas[i] =TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
      Nu=Nus[i],
      D=dimensions[i],
      lambda=mediums1[i].lambda);
  end for;
  annotation (Documentation(info="<html>
<p>The Borishanskii et al. is a liquid metal rod bundle heat transfer correlation.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">AlanE.&nbsp;Waltar,&nbsp;Donald&nbsp;R.&nbsp;Todd,&nbsp;Pavel&nbsp;V.&nbsp;Tsvetkov</p>
<p style=\"margin-left: 30px;\">Fast&nbsp;Spectrum&nbsp;Reactors&nbsp;2012</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;9.33ab&nbsp;pg.&nbsp;257</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>1.1 &LT;= Pitch/Diameter &LT;= 1.5</li>
<li>Peclet Number &LT;= 1000</li>
</ul>
</html>"));
end Borishanskii;
