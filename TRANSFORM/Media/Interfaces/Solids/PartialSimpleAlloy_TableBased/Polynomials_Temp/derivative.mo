within TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function derivative "Derivative of polynomial"
  extends Modelica.Icons.Function;
  input Real p1[:]
    "Polynomial coefficients (p1[1] is coefficient of highest power)";
  output Real p2[size(p1, 1) - 1] "Derivative of polynomial p1";
protected
  Integer n=size(p1, 1);
algorithm
  for j in 1:n - 1 loop
    p2[j] := p1[j]*(n - j);
  end for;
end derivative;
