within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal;
function Nu_GraberRieger

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real PDratio "Tube Pitch to Diameter ratio";

  output SI.NusseltNumber Nu "Nusselt number - S1:Eq. 9.34";

protected
  SI.PecletNumber Pe=TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Re,
      Pr);
algorithm
  Nu :=0.25 + 6.2*PDratio + (0.32*PDratio - 0.007)*Pe^(0.8 - 0.024*PDratio);

  annotation (Documentation(info="<html>
<p>The Graber-Rieger is a liquid metal rod bundle heat transfer correlation.</p>
<p>Range of Validity:</p>
<ul>
<li>liquid metal coolant</li>
<li>150 &LT;= Pe &LT;= 3000</li>
<li>1.25 &LT; Pitch/Diameter &LT;= 1.95</li>
</ul>
<h4>References</h4>
<ol>
<li>AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov, Fast Spectrum Reactors 2012</li>
</ol>
</html>"));
end Nu_GraberRieger;
