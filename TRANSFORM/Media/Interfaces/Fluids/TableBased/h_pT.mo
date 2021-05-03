within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function h_pT "Compute specific enthalpy from pressure and temperature"
  import Modelica.Units.Conversions.to_degC;
  extends Modelica.Icons.Function;
  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input Boolean densityOfT = false "Include or neglect density derivative dependence of enthalpy";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T";
algorithm
  h := h0 + Polynomials.integralValue(
      poly_Cp,
      if TinK then T else to_degC(T),
      if TinK then T0 else to_degC(T0)) + (p - reference_p)/
    Polynomials.evaluate(poly_rho, if TinK then T else to_degC(T))*(if
    densityOfT then (1 + T/Polynomials.evaluate(poly_rho, if TinK then T
     else to_degC(T))*Polynomials.derivativeValue(poly_rho, if TinK then T
     else to_degC(T))) else 1.0);
 annotation(smoothOrder=2);
end h_pT;
