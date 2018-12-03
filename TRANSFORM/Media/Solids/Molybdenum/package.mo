within TRANSFORM.Media.Solids;
package Molybdenum "Pure natural Molybdenum"

//cp from Chase, M.W., Jr., NIST-JANAF Themochemical Tables, Fourth Edition, J. Phys. Chem. Ref. Data, Monograph 9, 1998, 1-1951.
//https://webbook.nist.gov/cgi/cbook.cgi?ID=C7440337&Units=SI&Mask=2#Thermo-Condensed

//lambda from https://ntrs.nasa.gov/search.jsp?R=19670013537

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="Molybdenum",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=2896,
    MM_const=0.09596);
    constant Modelica.SIunits.Temperature trans = 1900;
    constant Real A[2] = {24.72736,  1231.192};
    constant Real B[2] = { 3.960425, -963.4246};
    constant Real C[2] = {-1.270706,  283.7292};
    constant Real D[2] = { 1.153065,  -28.04100};
    constant Real E[2] = {-0.170246, -712.2047};
    constant Real F[2] = {-8.110684,-1485.529};
    constant Real G[2] = {56.43379,   573.7854};
    constant Real H[2] = { 0.000000,    0.000000};
    constant Real a = 158.59;
    constant Real b = -52.16;
    constant Real c = 6.05;

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
protected
            Real t = state.T/1000;
            SI.SpecificEnthalpy h_lo, h_hi;
  algorithm
    h_lo := A[1]*t + B[1]/2*t^2 + C[1]/3*t^3 + D[1]/4*t^4 - E[1]/t + F[1] - H[1];
    h_hi := A[2]*t + B[2]/2*t^2 + C[2]/3*t^3 + D[2]/4*t^4 - E[2]/t + F[2] - H[2];
    h := h_reference + TRANSFORM.Math.spliceTanh(h_hi,h_lo,state.T-trans,100)/MM_const;
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 10220;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
protected
    Real t = state.T/1000;
  algorithm
    lambda := a + b*t + c*t^2;
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
end Molybdenum;
