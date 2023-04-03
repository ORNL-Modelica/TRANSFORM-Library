within TRANSFORM.Media.Solids;
package Alumina "Alumina Al2-O3"

  // http://www.haynesintl.com/alloys/alloy-portfolio_/Corrosion-resistant-Alloys/hastelloy-n-alloy/physical-properties

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Al2_O3",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 577.7784*(state.T - T_reference); //Doesn't matter
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 3950; //kg/m^3
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 5.85 + 15360*exp(-0.002*(state.T-273.15))/((state.T-273.15)+516); //W/m*K
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 1117+0.14*(state.T-273.15)-411*exp(-0.006*(state.T-273.15)); //(J/kg*k)
  end specificHeatCapacityCp;
annotation (Documentation(info="<html>
<p>Properties for a Sintered alpha-alumina product. </p>
</html>"));
end Alumina;
