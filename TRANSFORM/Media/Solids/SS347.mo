within TRANSFORM.Media.Solids;
package SS347 "SS347: Stainless steel 347"
  // Fits determined from two points at 100C and 500C (16.3 and 21.5 W/mk)
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="SS347",
    T_min=Modelica.Units.Conversions.from_degC(-250),
    T_max=Modelica.Units.Conversions.from_degC(2446));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 500*(state.T - T_reference);
    annotation(smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 8000;
    annotation(smoothOrder=2);
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 11.44905 + 0.013*state.T;
    annotation(smoothOrder=2);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 500;
    annotation(smoothOrder=2);
  end specificHeatCapacityCp;
end SS347;
