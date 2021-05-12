within TRANSFORM.Media.Solids;
package C276 "Alloy C-276 Corrosion Resistant"

  // https://www.specialmetals.com/assets/smc/documents/alloys/inconel/inconel-alloy-c-276.pdf

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Alloy C-276",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1100));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 577.7784*(state.T - T_reference);// Assume based on similarities between the two alloys
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 8890;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 1.72E-02*state.T + 4.98995531;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 427;
  end specificHeatCapacityCp;
end C276;
