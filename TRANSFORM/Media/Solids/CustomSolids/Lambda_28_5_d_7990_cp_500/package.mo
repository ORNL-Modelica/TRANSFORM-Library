within TRANSFORM.Media.Solids.CustomSolids;
package Lambda_28_5_d_7990_cp_500 "Custom: lambda = 28.5 | d = 7000 | cp = 680"
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="GenericSolid",
    T_min=0,
    T_max=1e6);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 680*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 7000;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 28.5;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 680;
  end specificHeatCapacityCp;
end Lambda_28_5_d_7990_cp_500;
