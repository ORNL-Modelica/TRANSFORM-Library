within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCp_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_cp;
algorithm
  der_cp := cp_T_coef[1];
  annotation (Inline=true);
end specificHeatCapacityCp_T_der;
