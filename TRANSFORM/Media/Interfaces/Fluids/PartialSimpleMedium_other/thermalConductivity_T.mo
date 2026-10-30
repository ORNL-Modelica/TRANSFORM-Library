within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function thermalConductivity_T
  input Temperature T "Temperature";
  output ThermalConductivity lambda "Thermal conductivity";
algorithm
  lambda := lambda_T_coef[1]*T + lambda_T_coef[2];
  annotation (Inline=true, derivative=density_T_der);
end thermalConductivity_T;
