within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_2 "Bundle Geometry Factor"
  input SI.Length D_htr "Heater element diameter";
  input SI.Length Pitch "Center distance between heating elements";
  input SIadd.NonDim x_abs "Absolute quality";

  output Real K "Correction factor";

protected
  SI.Length delta;
  Real arg;

algorithm
  assert(Pitch >= D_htr,"Pitch must be >= D_htr");

  delta := Pitch - D_htr;
  arg := (0.5 + 2*delta/D_htr)*exp(-max(0, x_abs)^(1/3)/2);
  K := min(1.0, arg);
end K_2;
