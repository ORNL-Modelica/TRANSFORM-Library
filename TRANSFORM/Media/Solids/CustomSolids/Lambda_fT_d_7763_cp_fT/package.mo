within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_fT_d_7763_cp_fT "Lambda_fT_d_7763_cp_fT"

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
    lambda := -0.0469*state.T + 76.813;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 0.3986*state.T + 341.74;
  end specificHeatCapacityCp;
end Lambda_fT_d_7763_cp_fT;
