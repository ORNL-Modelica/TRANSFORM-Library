within TRANSFORM.Media.Solids;
package SS304 "SS304: Stainless steel 304"

  // Fits are taken from aksteel.com for 304 steel.

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="SS304",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 500*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 8030;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 11.34905 + 0.013*state.T;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 500;
  end specificHeatCapacityCp;
end SS304;
