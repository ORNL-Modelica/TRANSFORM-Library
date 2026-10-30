within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.InternalFlow;
function Sh_Transition_Local_Developed_Circular_Whitaker
  // 2030 < Re < 1e4. Stempien thesis pg 155-157
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.SchmidtNumber Sc "Schmidt number";
  output Units.SherwoodNumber Sh "Sherwood number";
algorithm
  Sh := 0.015*Re^0.83*Sc^0.42;
end Sh_Transition_Local_Developed_Circular_Whitaker;
