within TRANSFORM.Media.Solids;
package UC "Uranium Carbide"

 // 1.P. L. KIRILLOV, “Thermophysical Properties of Materials for Nuclear Engineering,” UDK 621.039.53/54 (031), Institute for Hat and Mass Transfer in Nuclear Power Plants (2006).

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="alloyN",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(3000));

    constant Real porosity = 0 "Porosity of solid";

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + (0.2397*(state.T-T_reference) - 5.068e-6*(state.T-T_reference)^2/2 + 1.7604e-8*(state.T-T_reference)^3/3 + 3488.1*(1/state.T - 1/T_reference))*1000;

  end specificEnthalpy;

  redeclare function extends density
    "Density"

protected
  Real T_degC = state.T - 273.15;

  algorithm
  d := 13630*(1-3.117e-5*T_degC - 3.51e-9*T_degC^2);
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
protected
  Real T_degC = state.T - 273.15;

  algorithm
  lambda :=TRANSFORM.Math.spliceTanh(
    20.2 + 1.48e-3*T_degC,
    21.7 - 3.04e-3*T_degC + 3.61e-6*T_degC^2,
    T_degC-700,
    10)*(1-porosity)/(1+porosity);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
  cp :=(0.2397 - 5.068e-6*state.T + 1.7604e-8*state.T^2 - 3488.1/state.T^2)*1000;
  end specificHeatCapacityCp;
end UC;
