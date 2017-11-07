within TRANSFORM.Media.Interfaces.PartialSimpleAlloy_TableBased.Polynomials_Temp;
function integralValue "Integral of polynomial p(u) from u_low to u_high"
  extends Modelica.Icons.Function;
  input Real p[:] "Polynomial coefficients";
  input Real u_high "High integrand value";
  input Real u_low=0 "Low integrand value, default 0";
  output Real integral=0.0 "Integral of polynomial p from u_low to u_high";
protected
  Integer n=size(p, 1) "Degree of integrated polynomial";
  Real y_low=0 "Value at lower integrand";
algorithm
  for j in 1:n loop
    integral := u_high*(p[j]/(n - j + 1) + integral);
    y_low := u_low*(p[j]/(n - j + 1) + y_low);
  end for;
  integral := integral - y_low;
  annotation (derivative(zeroDerivative=p) = integralValue_der);
end integralValue;
