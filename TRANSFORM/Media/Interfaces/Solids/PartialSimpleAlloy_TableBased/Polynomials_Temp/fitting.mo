within TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function fitting
  "Computes the coefficients of a polynomial that fits a set of data points in a least-squares sense"
  extends Modelica.Icons.Function;
  input Real u[:] "Abscissa data values";
  input Real y[size(u, 1)] "Ordinate data values";
  input Integer n(min=1)
    "Order of desired polynomial that fits the data points (u,y)";
  output Real p[n + 1]
    "Polynomial coefficients of polynomial that fits the date points";
protected
  Real V[size(u, 1),n + 1] "Vandermonde matrix";
algorithm
  // Construct Vandermonde matrix
  V[:, n + 1] := ones(size(u, 1));
  for j in n:-1:1 loop
    V[:, j] := {u[i]*V[i, j + 1] for i in 1:size(u, 1)};
  end for;

  // Solve least squares problem
  p := Modelica.Math.Matrices.leastSquares(V, y);
  annotation (Documentation(info="<html>
<p>
Polynomials.fitting(u,y,n) computes the coefficients of a polynomial
p(u) of degree \"n\" that fits the data \"p(u[i]) - y[i]\"
in a least squares sense. The polynomial is
returned as a vector p[n+1] that has the following definition:
</p>
<pre>
  p(u) = p[1]*u^n + p[2]*u^(n-1) + ... + p[n]*u + p[n+1];
</pre>
</html>"));
end fitting;
