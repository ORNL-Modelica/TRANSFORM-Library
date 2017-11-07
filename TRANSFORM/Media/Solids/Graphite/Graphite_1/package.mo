within TRANSFORM.Media.Solids.Graphite;
package Graphite_1 "Graphite | fluence = 0.2e25 [n/m2]"

  extends TRANSFORM.Media.Interfaces.PartialSimpleAlloy(
    mediumName="Graphite",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + specificHeatCapacityCp(state)*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 1776.66;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 90.1445 - 3.64930e-2*state.T - 3.42932e-6*state.T^2 + 4.56817e-9*state.T^3;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := -143.9883 + 3.6677*state.T - 0.0022*state.T^2 + 4.6251e-7*state.T^3;
  end specificHeatCapacityCp;
end Graphite_1;
