within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_1 "Diameter Effect Factor"
  input SI.Length D_hyd "Hydraulic diameter of subchannel";
  output Real K "Correction factor";
algorithm
  if D_hyd < 0.002 then
    K := 1;
  elseif D_hyd > 0.025 then
    K := 0.57;
  else
    K := sqrt(0.008/D_hyd);
  end if;
end K_1;
