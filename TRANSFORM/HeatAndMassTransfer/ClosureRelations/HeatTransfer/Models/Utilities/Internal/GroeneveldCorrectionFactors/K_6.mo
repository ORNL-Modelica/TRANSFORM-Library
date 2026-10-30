within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_6
  "Radial/Circumferential (R/C) Flux Distribution Factor"
  input SI.HeatFlux q_rc_avg "Average R/C flux at a height z";
  input SI.HeatFlux q_rc_max "Maximum R/C flux at a height z";
  input SIadd.NonDim x_abs "Absolute quality";
  output Real K "Correction factor";
algorithm
  if x_abs > 0 then
    K := q_rc_avg/q_rc_max;
  else
    K := 1;
  end if;
end K_6;
