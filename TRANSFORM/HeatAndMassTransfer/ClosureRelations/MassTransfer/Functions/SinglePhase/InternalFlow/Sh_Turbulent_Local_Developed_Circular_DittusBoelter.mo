within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.InternalFlow;
function Sh_Turbulent_Local_Developed_Circular_DittusBoelter

  // Re > 1e4. Stempien thesis pg 155-157

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.SchmidtNumber Sc "Schmidt number";

  output Units.SherwoodNumber Sh "Sherwood number";

algorithm
  Sh := 0.023*Re^0.8*Sc^0.4;

end Sh_Turbulent_Local_Developed_Circular_DittusBoelter;
