within TRANSFORM.Media.Interfaces.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function derivativeValue_der "Time derivative of derivative of polynomial"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real u "Abscissa value";
  input Real du "Delta of abscissa value";
  output Real dy
    "Time-derivative of derivative of polynomial w.r.t. input variable at u";
protected
  Integer n=size(p, 1);
algorithm
  dy := secondDerivativeValue(p, u)*du;
end derivativeValue_der;
