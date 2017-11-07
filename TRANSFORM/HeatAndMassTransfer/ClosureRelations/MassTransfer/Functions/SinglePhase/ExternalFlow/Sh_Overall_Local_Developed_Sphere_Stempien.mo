within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.ExternalFlow;
function Sh_Overall_Local_Developed_Sphere_Stempien

  // 22 < Re < 8000. Stempien thesis pg 149-150

  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.SchmidtNumber Sc "Schmidt number";

  output Units.SherwoodNumber Sh "Sherwood number";

algorithm
  Sh := (0.5*Re^0.5+0.2*Re^(2/3))*Sc^(1/3);

end Sh_Overall_Local_Developed_Sphere_Stempien;
