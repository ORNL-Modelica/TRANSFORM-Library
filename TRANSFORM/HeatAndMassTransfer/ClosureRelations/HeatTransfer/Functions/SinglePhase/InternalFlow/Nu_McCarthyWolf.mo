within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_McCarthyWolf
  "McCarthy-Wolf turbulent heat transfer correlation for one-phase flow in a tube Nu = A*Re^alpha*Pr^beta*(Tb/Tw)^gamma"

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real TemperatureRatio "Ratio of bulk to wall temperature";
  input Real A = 0.025 "Multiplication value";
  input Real B = 1.06 "Entrance effect approximation";
  input Real alpha = 0.8 "Exponent to Reynolds number";
  input Real beta = 0.4 "Exponent to Prandtl number";
  input Real gamma = 0.55 "Exponent to Temperature ratio";
  output SI.NusseltNumber Nu "Nusselt number";

algorithm
  Nu := A*B*Re^alpha*Pr^beta*TemperatureRatio^gamma;

  annotation (Documentation(info="<html>
  <p>McCarthy-Wolf turbulent flow heat transfer correlation. Given in WANL-TME-2697 in equation 12. Entrance effect ignored (replaced with 1.06, for when x/D = 10).  </p>
</html>"));
end Nu_McCarthyWolf;
