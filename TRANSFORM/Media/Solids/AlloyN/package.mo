within TRANSFORM.Media.Solids;
package AlloyN "AlloyN: Material properties for Alloy-N (R)"
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="alloyN",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 4.614019521e-4*(state.T^3 - T_reference^3)/3 - 0.3402230706309*(state.T^2 - T_reference^2)/2 + 488.9450478878976*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 8860;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 1.4642857143e-5*state.T^2 - 3.20821428571e-4*state.T + 9.766543865178583;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 4.614019521e-4*state.T^2 - 0.3402230706309*state.T + 488.9450478878976;
  end specificHeatCapacityCp;
end AlloyN;
