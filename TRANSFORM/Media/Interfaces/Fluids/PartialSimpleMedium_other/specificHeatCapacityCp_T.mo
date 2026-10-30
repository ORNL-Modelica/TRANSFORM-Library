within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCp_T
  input Temperature T "Temperature";
  output SpecificHeatCapacity cp "Specific heat capacity";
algorithm
  cp := cp_T_coef[1]*T + cp_T_coef[2];
  annotation (
    Inline=false,
    LateInline=true,
    derivative=specificHeatCapacityCp_T_der);
end specificHeatCapacityCp_T;
