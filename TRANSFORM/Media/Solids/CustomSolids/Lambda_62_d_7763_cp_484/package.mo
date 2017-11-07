within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_62_d_7763_cp_484 "Custom: lambda = 62 | d = 7763 | cp = 484"

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
    d := 7763;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 62;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 484;
  end specificHeatCapacityCp;
end Lambda_62_d_7763_cp_484;
