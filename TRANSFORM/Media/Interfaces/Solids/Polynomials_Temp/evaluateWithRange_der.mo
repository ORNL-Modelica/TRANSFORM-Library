within TRANSFORM.Media.Interfaces.Solids.Polynomials_Temp;
function evaluateWithRange_der
  "Evaluate derivative of polynomial at a given abscissa value with extrapolation outside of the defined range"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real uMin "Polynomial valid in the range uMin .. uMax";
  input Real uMax "Polynomial valid in the range uMin .. uMax";
  input Real u "Abscissa value";
  input Real du "Delta of abscissa value";
  output Real dy "Value of derivative of polynomial at u";
algorithm
  if u < uMin then
    dy := evaluate_der(
      p,
      uMin,
      du);
  elseif u > uMax then
    dy := evaluate_der(
      p,
      uMax,
      du);
  else
    dy := evaluate_der(
      p,
      u,
      du);
  end if;
end evaluateWithRange_der;
