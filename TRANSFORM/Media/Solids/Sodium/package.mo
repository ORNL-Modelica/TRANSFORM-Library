within TRANSFORM.Media.Solids;
package Sodium "Liquid Sodium: thermal properties of liquid sodium"
extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
  mediumName="Na_liquid",
  T_min=Modelica.Units.Conversions.from_degC(0),
  T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 1251*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 791;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 58.41;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 1251;
  end specificHeatCapacityCp;
end Sodium;
