within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function h_T_der "Compute specific enthalpy from temperature"
  import Modelica.Units.Conversions.to_degC;
  extends Modelica.Icons.Function;
  input SI.Temperature T "Temperature";
  input Real dT "Temperature derivative";
  output Real dh "Derivative of Specific enthalpy at T";
algorithm
  dh := Polynomials.evaluate(poly_Cp, if TinK then T else to_degC(T))*dT;
 annotation(smoothOrder=1);
end h_T_der;
