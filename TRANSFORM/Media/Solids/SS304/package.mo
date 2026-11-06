within TRANSFORM.Media.Solids;
package SS304 "SS304: Stainless steel 304"
  // Fits are taken from aksteel.com for 304 steel.
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="SS304",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500));

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
    // max(state.T, 0): below 0 K this fit reaches zero at -873 K, where a solver searching for a start
    // can find a false steady state with no conduction (see SS316). No value at a real
    // temperature changes.
    lambda := 11.34905 + 0.013*max(state.T, 0);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 500;
  end specificHeatCapacityCp;
end SS304;
