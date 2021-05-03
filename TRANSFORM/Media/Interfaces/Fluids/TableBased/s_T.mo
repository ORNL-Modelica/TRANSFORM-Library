within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function s_T "Compute specific entropy"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output SpecificEntropy s "Specific entropy";
algorithm
  s := s0 + (if TinK then Polynomials.integralValue(
      poly_Cp[1:npol],
      T,
      T0) else Polynomials.integralValue(
      poly_Cp[1:npol],
      Modelica.Units.Conversions.to_degC(T),
      Modelica.Units.Conversions.to_degC(T0))) + Modelica.Math.log(T/T0)*
    Polynomials.evaluate(poly_Cp, if TinK then 0 else Modelica.Constants.T_zero);
 annotation(Inline=true,smoothOrder=2);
end s_T;
