within TRANSFORM.Media.Solids;
package Beryllium "Pure natural Beryllium"
//cp from Chase, M.W., Jr., NIST-JANAF Themochemical Tables, Fourth Edition, J. Phys. Chem. Ref. Data, Monograph 9, 1998, 1-1951.
//https://webbook.nist.gov/cgi/cbook.cgi?ID=C7440417&Units=SI&Mask=2#Thermo-Condensed
//lambda from my imagination
extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
  mediumName="Beryllium",
  T_min=Modelica.Units.Conversions.from_degC(-273),
  T_max=1560,
  MM_const=0.009012182);
constant Modelica.Units.SI.Temperature trans=1527;
    constant Real A[2] = { 21.20694,  30.00037};
    constant Real B[2] = {  5.688190, -0.000396};
    constant Real C[2] = {  0.968019,  0.000169};
    constant Real D[2] = { -0.001749, -0.000026};
    constant Real E[2] = { -0.587526, -0.000105};
    constant Real F[2] = { -8.554858, -6.970377};
    constant Real G[2] = { 30.06007,  40.76178};
    constant Real H[2] = {  0.000000,  0.000000};

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
protected
            Real t = state.T/1000;
            SI.SpecificEnthalpy h_lo, h_hi;
  algorithm
    h_lo := A[1]*t+B[1]/2*t^2+C[1]/3*t^3+D[1]/4*t^4-E[1]/t+F[1]-H[1];
    h_hi := A[2]*t+B[2]/2*t^2+C[2]/3*t^3+D[2]/4*t^4-E[2]/t+F[2]-H[2];
    h := h_reference + TRANSFORM.Math.spliceTanh(h_hi,h_lo,state.T-trans,100)/MM_const;
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 1850;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 120;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
protected
            Real t = state.T/1000;
            SI.SpecificHeatCapacity cp_lo, cp_hi;
  algorithm
    cp_lo :=A[1] + B[1]*t + C[1]*t^2 + D[1]*t^3 + E[1]/t^2;
    cp_hi :=A[2] + B[2]*t + C[2]*t^2 + D[2]*t^3 + E[2]/t^2;
    cp := TRANSFORM.Math.spliceTanh(cp_hi,cp_lo,state.T-trans,100)/MM_const;
  end specificHeatCapacityCp;
end Beryllium;
