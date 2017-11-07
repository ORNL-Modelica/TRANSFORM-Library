within TRANSFORM.Media.Solids;
package Helium "Helium: pseudo-Helium gas/solid"

  /*
Helium Thermal capacity, density, and specific heat.

The properties are just rough estimates (placeholders) for now.

IAEA. Thermophysical Properties of Materials for Nuclear Engineering:
A Tutorial and Collection of Data. IAEA-THPH. ISBN 978-92-0-106508-7. 2008

Taken at pressure = 1e5 Pa
k => regression from pg 57 table (units in table are wrong, off by 1000)
rho => regression from pg 57 table
cp => pg 56
*/

  extends TRANSFORM.Media.Interfaces.PartialSimpleAlloy(
    mediumName="He",
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
    d := 0.165 - 4.3e-4*state.T + 6.7e-7*state.T^2 - 5.5e-10*state.T^3 + 1.7e-13*state.T^4;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 0.1449 + 3e-4*state.T - 3e-8*state.T^2 - 9e-11*state.T^3 + 5e-14*state.T^4;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 5193;
  end specificHeatCapacityCp;
end Helium;
