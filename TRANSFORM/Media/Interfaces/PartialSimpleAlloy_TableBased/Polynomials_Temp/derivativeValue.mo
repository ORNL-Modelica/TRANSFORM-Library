within TRANSFORM.Media.Interfaces.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function derivativeValue
  "Value of derivative of polynomial at abscissa value u"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real u "Abscissa value";
  output Real y "Value of derivative of polynomial at u";
protected
  Integer n=size(p, 1);
algorithm
  y := p[1]*(n - 1);
  for j in 2:size(p, 1) - 1 loop
    y := p[j]*(n - j) + u*y;
  end for;
  annotation (derivative(zeroDerivative=p) = derivativeValue_der);
end derivativeValue;
