within TRANSFORM.Media.Solids;
package Rhenium "Pure natural Rhenium"
//cp from http://www.dtic.mil/docs/citations/AD0806940 via lambda ref below
//lambda from http://www.dtic.mil/docs/citations/AD0807299
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Rhenium",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=3453,
    MM_const=0.186207);
    constant Real A = 3.023e-2;
    constant Real B = 5.81e-6;
    constant Real a = 0.601;
    constant Real b = -0.712e-4;

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + (A*state.T + B/2*state.T^2)*4186.8-3.987714e4;
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 20800;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := (a + b*state.T)*100;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := (A + B*state.T)*4186.8;
  end specificHeatCapacityCp;
end Rhenium;
