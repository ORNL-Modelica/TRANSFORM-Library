within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_DittusBoelter
  "Dittus-Boelter correlation for one-phase flow in a tube"

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";

  output SI.NusseltNumber Nu "Nusselt number";

algorithm
  Nu := 0.023*Re^0.8*Pr^0.4;

  annotation (Documentation(info="<html>
<p>Dittus-Boelter&apos;s correlation for the computation of the heat transfer coefficient in one-phase flows. </p>
</html>"));
end Nu_DittusBoelter;
