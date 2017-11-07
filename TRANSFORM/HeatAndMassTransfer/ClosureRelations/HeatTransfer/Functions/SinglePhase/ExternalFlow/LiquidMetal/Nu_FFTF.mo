within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal;
function Nu_FFTF

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real PDratio "Tube Pitch to Diameter ratio";

  output SI.NusseltNumber Nu "Nusselt number - S1:Eq. 9.35";

protected
  SI.PecletNumber Pe=TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Re,
      Pr);

algorithm
  Nu := 4.0 + 0.16*PDratio^5.0 + 0.33*PDratio^3.8*(Pe/100)^0.86;

  annotation (Documentation(info="<html>
<p>The FFTF liquid metal rod bundle heat transfer correlation was created for the Fast Fission Test Facility (FFTF) fuel assembly.</p>
<p>Range of Validity:</p>
<ul>
<li>liquid metal coolant</li>
<li>20 &LT;= Pe &LT;= 1000</li>
</ul>
<h4>References</h4>
<ol>
<li>AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov, Fast Spectrum Reactors 2012</li>
</ol>
</html>"));
end Nu_FFTF;
