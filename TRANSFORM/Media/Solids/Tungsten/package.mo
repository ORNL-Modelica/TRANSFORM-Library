within TRANSFORM.Media.Solids;
package Tungsten "Pure natural Tungsten"

//cp from Chase, M.W., Jr., NIST-JANAF Themochemical Tables, Fourth Edition, J. Phys. Chem. Ref. Data, Monograph 9, 1998, 1-1951.
//https://webbook.nist.gov/cgi/cbook.cgi?ID=C7440337&Units=SI&Mask=2#Thermo-Condensed

//lambda from Webb & Charit, 10.1016/j.jnucmat.2012.04.020

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Tungsten",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=3680,
    MM_const=0.18384);
    constant Modelica.SIunits.Temperature trans = 1900;
    constant Real A[2] = { 23.95930, -22.57640};
    constant Real B[2] = {  2.639680, 90.27980};
    constant Real C[2] = {  1.257750,-44.27150};
    constant Real D[2] = { -0.254642,  7.176630};
    constant Real E[2] = { -0.048407,-24.09740};
    constant Real F[2] = { -7.433250, -9.978731};
    constant Real G[2] = { 60.54290, -14.24470};
    constant Real H[2] = {  0.000000,  0.000000};



  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 500*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 19300;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := -35.911*log(state.T)+373.062;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := A[i]*t;
  end specificHeatCapacityCp;
end Tungsten;
