within TRANSFORM.Media.Solids.Graphite;
package Graphite_3 "Graphite | fluence = 1e25 [n/m2]"
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Graphite",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(1500));
  constant Real c1(unit="J/(kg.K)") = -143.9883;
  constant Real c2(unit="J/(kg.K2)") = 3.6677;
  constant Real c3(unit="J/(kg.K3)") = -0.0022;
  constant Real c4(unit="J/(kg.K4)") = 4.6251e-7;

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + c1*(state.T - T_reference) + c2*(state.T^2 - T_reference^2)/2 + c3*(state.T^
      3 - T_reference^3)/3 + c4*(state.T^4 - T_reference^4)/4;
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 1776.66;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 30.5337 - 1.55010e-3*state.T - 5.51300e-6*state.T^2 + 2.03348e-9*state.T^3;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := c1 + c2*state.T + c3*state.T^2 + c4*state.T^3;
  end specificHeatCapacityCp;
end Graphite_3;
