within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function h_T "Compute specific enthalpy from temperature"
  import Modelica.Units.Conversions.to_degC;
  extends Modelica.Icons.Function;
  input SI.Temperature T "Temperature";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T";
algorithm
  h := h0 + Polynomials.integralValue(
      poly_Cp,
      if TinK then T else to_degC(T),
      if TinK then T0 else to_degC(T0));
 annotation(derivative=h_T_der);
end h_T;
