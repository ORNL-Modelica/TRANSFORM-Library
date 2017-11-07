within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_0_35_d_1100_cp_1900 "Custom: lambda = 0.35 | d = 1100 | cp = 1900"

  extends TRANSFORM.Media.Interfaces.PartialSimpleAlloy(
    mediumName="GenericSolid",
    T_min=0,
    T_max=1e6);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + specificHeatCapacityCp(state)*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 1100;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 0.35;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 1900;
  end specificHeatCapacityCp;
end Lambda_0_35_d_1100_cp_1900;
