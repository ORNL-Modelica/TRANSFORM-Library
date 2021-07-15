within TRANSFORM.Media.Interfaces.Solids.Polynomials_Temp;
function evaluate "Evaluate polynomial at a given abscissa value"
  extends Modelica.Icons.Function;
  input Real p[:]
    "Polynomial coefficients (p[1] is coefficient of highest power)";
  input Real u "Abscissa value";
  output Real y "Value of polynomial at u";
algorithm
  y := p[1];
  for j in 2:size(p, 1) loop
    y := p[j] + u*y;
  end for;
  annotation (derivative(zeroDerivative=p) = evaluate_der);
end evaluate;
