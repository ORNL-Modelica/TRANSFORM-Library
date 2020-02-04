within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_SiederTate "Sieder-Tate correlation based on Peclet number"
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Real R_mu "Ratio of dynamic viscosity (@T_bulk/@T_wall)";
  input Real A = 0.027 "Multiplication value";
  input Real alpha = 0.8 "Exponent to Reynolds number";
  input Real beta = 1/3 "Exponent to Prandtl number";
  input Real delta = 0.14 "Exponent on viscosity ratio";
  output SI.NusseltNumber Nu "Nusselt number";
algorithm
  Nu := A*Re^alpha*Pr^beta*R_mu^delta;
  annotation (Documentation(info="<html>
</html>"));
end Nu_SiederTate;
