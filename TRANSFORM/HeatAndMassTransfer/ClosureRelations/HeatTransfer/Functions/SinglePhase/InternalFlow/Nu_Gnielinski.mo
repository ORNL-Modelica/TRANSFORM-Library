within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Gnielinski
  "Gnielinski correlation for one-phase flow in a tube Nu = A*(Re+B)*Pr/1+C*(Pr^D-E)"
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  output SI.NusseltNumber Nu "Nusselt number";
protected
            Real f = (0.79*ln(Re)-1.64)^(-2) "Friction factor";
algorithm
  Nu := ((f/8)*(Re-1000)*Pr)/(1+12.7*(f/8)^0.5*(Pr^(2/3)-1));
  annotation (Documentation(info="<html>
<p>Dittus-Boelter&apos;s correlation for the computation of the heat transfer coefficient in one-phase flows. </p>
</html>"));
end Nu_Gnielinski;
