within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCp_h
  input SpecificEnthalpy h "Specific enthalpy";
  output SpecificHeatCapacity cp "Specific heat capacity";
algorithm
  cp := cp_h_coef[1]*h + cp_h_coef[2];
  annotation (Inline=true, derivative=specificHeatCapacityCp_h_der);
end specificHeatCapacityCp_h;
