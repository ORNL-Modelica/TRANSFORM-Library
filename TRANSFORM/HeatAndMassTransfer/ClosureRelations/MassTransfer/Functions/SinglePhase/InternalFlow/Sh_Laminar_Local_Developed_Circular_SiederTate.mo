within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.InternalFlow;
function Sh_Laminar_Local_Developed_Circular_SiederTate

  // 13 < Re < 2030. Stempien thesis pg 155-157

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.SchmidtNumber Sc "Schmidt number";
  input SI.Length length "Total pipe length";
  input SI.Length dimension "Pipe diameter";

  output Units.SherwoodNumber Sh "Sherwood number";

algorithm
  Sh := 1.86*Re^(1/3)*Sc^(1/3)*(dimension/length)^(1/3);

end Sh_Laminar_Local_Developed_Circular_SiederTate;
