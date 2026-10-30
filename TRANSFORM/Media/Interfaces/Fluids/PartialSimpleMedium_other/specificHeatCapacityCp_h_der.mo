within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCp_h_der
  input SpecificEnthalpy h "Specific enthalpy";
  input Real der_h;
  output Real der_cp;
algorithm
  der_cp := cp_h_coef[1];
  annotation (Inline=true);
end specificHeatCapacityCp_h_der;
