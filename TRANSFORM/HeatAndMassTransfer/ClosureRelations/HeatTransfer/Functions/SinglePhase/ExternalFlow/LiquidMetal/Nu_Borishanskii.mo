within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal;
function Nu_Borishanskii
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real PDratio "Tube Pitch to Diameter ratio";
  output SI.NusseltNumber Nu "Nusselt number - S1:Eq. 9.33";
protected
  SI.PecletNumber Pe=TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Re,
      Pr);
algorithm
  Nu := 24.15*log10(-8.12 + 12.76*PDratio - 3.65*PDratio^2) + 0.0174*(1 -
    exp(-6*(PDratio - 1)))*(max(0, Pe - 200))^0.9;
  annotation (Documentation(info="<html>
<p>The Borishanskii et al. is a liquid metal rod bundle heat transfer correlation.</p>
<p>Range of Validity:</p>
<ul>
<li>liquid metal coolant</li>
<li>Pe &LT;= 1000</li>
<li>1.1 &LT; Pitch/Diameter &LT;= 1.5</li>
</ul>
<h4>References</h4>
<ol>
<li>AlanE. Waltar, Donald R. Todd, Pavel V. Tsvetkov, Fast Spectrum Reactors 2012</li>
</ol>
</html>"));
end Nu_Borishanskii;
