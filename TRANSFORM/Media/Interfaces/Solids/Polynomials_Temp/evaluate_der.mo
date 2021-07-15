within TRANSFORM.Media.Interfaces.Solids.Polynomials_Temp;
function evaluate_der
  "Evaluate derivative of polynomial at a given abscissa value"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real u "Abscissa value";
  input Real du "Delta of abscissa value";
  output Real dy "Value of derivative of polynomial at u";
protected
  Integer n=size(p, 1);
algorithm
  dy := p[1]*(n - 1);
  for j in 2:size(p, 1) - 1 loop
    dy := p[j]*(n - j) + u*dy;
  end for;
  dy := dy*du;
end evaluate_der;
