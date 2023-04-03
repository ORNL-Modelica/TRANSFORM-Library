within TRANSFORM.Media.Solids;
package FOAMGLAS "FOAMGLAS One"
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="FiberGlassGeneric",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 840.0*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 117;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 2.59916e-07*((state.T-273.15)^2) + 1.40496e-04*(state.T-273.15)+3.846e-02; //At 204C from Data Sheet
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 770.0;
  end specificHeatCapacityCp;
annotation (Documentation(info="<html>
<p>FOAMGLAS ONE. https://www.foamglas.com/en-us/products/blocks/one-standard-us</p>
</html>"));
end FOAMGLAS;
