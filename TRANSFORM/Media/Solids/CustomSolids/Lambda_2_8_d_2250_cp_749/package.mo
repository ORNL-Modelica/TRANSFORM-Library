within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_2_8_d_2250_cp_749 "Custom: lambda = 2.8 | d = 2250 | cp = 749"

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="GenericSolid",
    T_min=0,
    T_max=1e6);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 749*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 2250;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 2.8;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 749;
  end specificHeatCapacityCp;
end Lambda_2_8_d_2250_cp_749;
