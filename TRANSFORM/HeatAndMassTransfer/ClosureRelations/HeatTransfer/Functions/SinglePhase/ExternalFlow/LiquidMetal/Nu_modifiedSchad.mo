within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal;
function Nu_modifiedSchad
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real PDratio "Tube Pitch to Diameter ratio";
  output SI.NusseltNumber Nu "Nusselt number - S1:Eq. 9.36";
protected
  SI.PecletNumber Pe=TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Re,
      Pr);
algorithm
  Nu := 4.496*(-16.15 + 24.96*PDratio - 8.55*PDratio^2)*(max(150, Pe)/150)^0.3;
  annotation (Documentation(info="<html>
<p>The modified Schad is a liquid metal rod bundle heat transfer correlation.</p>
<p>Range of Validity:</p>
<ul>
<li>liquid metal coolant</li>
<li>Peclet Number &LT;= 1000</li>
<li>1.05 &LT;= Pitch/Diameter &LT;= 1.15</li>
</ul>
<h4>References</h4>
<ol>
<li>AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov, Fast Spectrum Reactors 2012</li>
</ol>
</html>"));
end Nu_modifiedSchad;
