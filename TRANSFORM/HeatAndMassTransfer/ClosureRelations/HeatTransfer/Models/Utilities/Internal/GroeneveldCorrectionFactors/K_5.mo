within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_5 "Axial Flux Distribution Factor"
  input SI.HeatFlux q_BLA "Boiling length average heat flux";
  input SI.HeatFlux q_local "Local heat flux";
  input SIadd.NonDim x_abs "Absolute quality";
  output Real K "Correction factor";
algorithm
  if x_abs > 0 then
    K := q_local/q_BLA;
  else
    K := 1;
  end if;
end K_5;
