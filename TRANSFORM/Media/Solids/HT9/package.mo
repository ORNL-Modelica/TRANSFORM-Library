within TRANSFORM.Media.Solids;
package HT9 "HT9: Material properties for HT9 a series 400 type stainless steel"
  // Fits are taken from aksteel.com for 400 steel. This is close.
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="HT9",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 460*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 7470;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    // max(state.T, 0): below 0 K this fit reaches zero at -530 K, where a solver searching for a start
    // can find a false steady state with no conduction (see SS316). No value at a real
    // temperature changes.
    lambda := 17.622 + 2.428e-2*max(state.T, 0) - 1.696e-5*max(state.T, 0)^2;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 460;
  end specificHeatCapacityCp;
end HT9;
