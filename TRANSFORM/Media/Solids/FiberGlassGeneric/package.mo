within TRANSFORM.Media.Solids;
package FiberGlassGeneric "Fiber Glass: Generic"
extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
  mediumName="FiberGlassGeneric",
  T_min=Modelica.Units.Conversions.from_degC(0),
  T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 234.4511*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 72.083;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 1.03001e-4*state.T+2.86571e-3;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 234.4511;
  end specificHeatCapacityCp;
end FiberGlassGeneric;
