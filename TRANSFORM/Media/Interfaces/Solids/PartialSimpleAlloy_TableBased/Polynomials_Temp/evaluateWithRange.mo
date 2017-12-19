within TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function evaluateWithRange
  "Evaluate polynomial at a given abscissa value with linear extrapolation outside of the defined range"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real uMin "Polynomial valid in the range uMin .. uMax";
  input Real uMax "Polynomial valid in the range uMin .. uMax";
  input Real u "Abscissa value";
  output Real y
    "Value of polynomial at u. Outside of uMin,uMax, linear extrapolation is used";
algorithm
  if u < uMin then
    y := evaluate(p, uMin) - evaluate_der(
      p,
      uMin,
      uMin - u);
  elseif u > uMax then
    y := evaluate(p, uMax) + evaluate_der(
      p,
      uMax,
      u - uMax);
  else
    y := evaluate(p, u);
  end if;
  annotation (derivative(
      zeroDerivative=p,
      zeroDerivative=uMin,
      zeroDerivative=uMax) = evaluateWithRange_der);
end evaluateWithRange;
