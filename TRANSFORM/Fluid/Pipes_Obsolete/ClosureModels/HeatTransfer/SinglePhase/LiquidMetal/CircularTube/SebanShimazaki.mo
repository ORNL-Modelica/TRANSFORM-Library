within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.SinglePhase.LiquidMetal.CircularTube;
model SebanShimazaki
  "Seban-Shimazaki: Liquid metal correlation for flow in circular tubes and uniform wall temperature"
  /* source: 
  M. M. Wakil
  Nuclear Heat Transport 1993
  eq. 10-3 pg. 268
  
  Valid for:
  - liquid metal coolant
  - flow in circular tubes
  - uniform wall temperature
  */
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer;
    Real[nHT] Pes "Peclet Number";
equation
  Pes = TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Res, Prs);
  for i in 1:nHT loop
    Nus[i] = 5.0 + 0.025*Pes[i]^0.8;
    alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
       Nu=Nus[i],
       D=dimensions[i],
       lambda=lambdas[i]);
  end for;
  annotation (Documentation(info="<html>
<p>The Seban-Shimazaki heat transfer correlation is for flow of liquid metal in circular tubes with uniform wall temperature.</p>
<p>The correlation was taken from the following textbook:</p>
<p style=\"margin-left: 30px;\">M.&nbsp;M.&nbsp;Wakil</p>
<p style=\"margin-left: 30px;\">Nuclear&nbsp;Heat&nbsp;Transport&nbsp;1993</p>
<p style=\"margin-left: 30px;\">eq.&nbsp;10-3&nbsp;pg.&nbsp;268</p>
<p>and is reported valid for:</p>
<ul>
<li>liquid metal coolant</li>
<li>flow in circular tubes</li>
<li>uniform wall temperature</li>
</ul>
</html>"));
end SebanShimazaki;
