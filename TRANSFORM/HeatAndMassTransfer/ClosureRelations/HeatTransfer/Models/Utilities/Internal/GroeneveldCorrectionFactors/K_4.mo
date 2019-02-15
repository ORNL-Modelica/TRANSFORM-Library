within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_4 "Heated Length Factor"
  input SI.Length D_hyd "Hydraulic diameter of subchannel";
  input SI.Length L_htd "Heated length";
  input SI.Density rho_lsat "Fluid saturation density";
  input SI.Density rho_vsat "Vapor saturation density";
  input SIadd.NonDim x_abs "Absolute quality";
  output Real K "Correction factor";
protected
  Real alpha;
algorithm
  alpha := x_abs*rho_lsat/(x_abs*rho_lsat + (1 - x_abs)*rho_vsat);
  if L_htd/D_hyd >= 5 then
    K := exp(D_hyd/L_htd*exp(2*alpha));
  else
    K := 1;
  end if;
end K_4;
