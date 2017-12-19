within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_230_d_2700_cp_1000 "Custom: lambda = 230 | d = 2700 | cp = 1000"

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="GenericSolid",
    T_min=0,
    T_max=1e6);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 1000*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 2700;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 230;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 1000;
  end specificHeatCapacityCp;
end Lambda_230_d_2700_cp_1000;
