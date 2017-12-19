within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_DittusBoelter
  "Dittus-Boelter correlation for one-phase flow in a tube Nu = A*Re^alpha*Pr^beta"

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real A = 0.023 "Multiplication value";
  input Real alpha = 0.8 "Exponent to Reynolds number";
  input Real beta = 0.4 "Exponent to Prandtl number";
  output SI.NusseltNumber Nu "Nusselt number";

algorithm
  Nu := A*Re^alpha*Pr^beta;

  annotation (Documentation(info="<html>
<p>Dittus-Boelter&apos;s correlation for the computation of the heat transfer coefficient in one-phase flows. </p>
</html>"));
end Nu_DittusBoelter;
