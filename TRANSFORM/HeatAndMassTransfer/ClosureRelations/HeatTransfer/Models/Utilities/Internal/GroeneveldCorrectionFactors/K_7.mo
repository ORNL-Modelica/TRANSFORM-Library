within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_7 "Flow-Orientation Factor"
  input SI.Length D_hyd "Hydraulic diameter of subchannel";
  input SIadd.NonDim f_L "Friction factor of the channel";
  input SIadd.MassFlux G "Mass flux";
  input SI.Density rho_lsat "Fluid saturation density";
  input SI.Density rho_vsat "Vapor saturation density";
  input SIadd.NonDim x_abs "Absolute quality";
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravity coefficient";

  output Real K "Correction factor";

protected
  Real alpha;
  Real T_1;

algorithm

  // This alpha should be changed to the correlation of Premoli et al. (1970)
  alpha := x_abs*rho_lsat/(x_abs*rho_lsat + (1 - x_abs)*rho_vsat);

  T_1 := ((1 - x_abs)/(1 - alpha))^2*f_L*abs(G)^2/(g_n*D_hyd*rho_lsat*(rho_lsat - rho_vsat)*sqrt(max(1e-6,alpha)));
  K := 1 - exp(-sqrt(T_1/3));
end K_7;
