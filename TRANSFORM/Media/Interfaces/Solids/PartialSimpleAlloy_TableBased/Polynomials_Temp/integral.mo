within TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function integral "Indefinite integral of polynomial p(u)"
  extends Modelica.Icons.Function;
  input Real p1[:]
    "Polynomial coefficients (p1[1] is coefficient of highest power)";
  output Real p2[size(p1, 1) + 1]
    "Polynomial coefficients of indefinite integral of polynomial p1 (polynomial p2 + C is the indefinite integral of p1, where C is an arbitrary constant)";
protected
  Integer n=size(p1, 1) + 1 "Degree of output polynomial";
algorithm
  for j in 1:n - 1 loop
    p2[j] := p1[j]/(n - j);
  end for;
  p2[n] := 0.0;
end integral;
