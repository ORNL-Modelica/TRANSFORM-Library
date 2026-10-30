within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCv_T
  input Temperature T "Temperature";
  output SpecificHeatCapacity cv "Specific heat capacity";
algorithm
  cv := cv_T_coef[1]*T + cv_T_coef[2];
  annotation (Inline=true, derivative=specificHeatCapacityCv_T_der);
end specificHeatCapacityCv_T;
