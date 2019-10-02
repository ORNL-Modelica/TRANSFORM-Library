within TRANSFORM.Media.Solids;
package Hastelloy_N_Haynes "Hastelloy-N from Haynes International"

  // http://www.haynesintl.com/alloys/alloy-portfolio_/Corrosion-resistant-Alloys/hastelloy-n-alloy/physical-properties 

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Alloy_N",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 577.7784*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 8860;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 1.928571e-5*state.T^2 - 7.407214e-3*state.T + 1.235864e1;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 577.7784;
  end specificHeatCapacityCp;
end Hastelloy_N_Haynes;
