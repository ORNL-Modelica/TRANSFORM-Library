within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.SinglePhase.LiquidMetal.TubeBundle;
model FFTF "FFTF: Liquid metal rod bundle; 20 <= Pe <= 1000"
  /* source: 
  AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov
  Fast Spectrum Reactors 2012
  eq. 9.35 pg. 257

  20 <= Pe <= 1000
  */
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer;
    parameter Real PDratio "Tube Pitch to Diameter ratio";
    Real[nHT] Pes "Peclet Number";
equation
  Pes = TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Res, Prs);
  for i in 1:nHT loop
    Nus[i] = 4.0 + 0.16*PDratio^5.0 + 0.33*PDratio^3.8*(Pes[i]/100)^0.86;
    alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
       Nu=Nus[i],
       D=dimensions[i],
       lambda=lambdas[i]);
  end for;
  annotation (Documentation(info="<html>
<p>The FFTF liquid metal rod bundle heat transfer correlation was created for the Fast Fission Test Facility (FFTF) fuel assembly.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">AlanE.&nbsp;Waltar,&nbsp;Donald&nbsp;R.&nbsp;Todd,&nbsp;Pavel&nbsp;V.&nbsp;Tsvetkov</p>
<p style=\"margin-left: 30px;\">Fast&nbsp;Spectrum&nbsp;Reactors&nbsp;2012</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;9.35&nbsp;pg.&nbsp;257</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>20 &LT;= Peclet Number &LT;= 1000</li>
</ul>
</html>"));
end FFTF;
