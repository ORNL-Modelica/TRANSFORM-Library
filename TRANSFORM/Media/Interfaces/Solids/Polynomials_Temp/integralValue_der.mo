within TRANSFORM.Media.Interfaces.Solids.Polynomials_Temp;
function integralValue_der
  "Time derivative of integral of polynomial p(u) from u_low to u_high, assuming only u_high as time-dependent (Leibniz rule)"
  extends Modelica.Icons.Function;
  input Real p[:] "Polynomial coefficients";
  input Real u_high "High integrand value";
  input Real u_low=0 "Low integrand value, default 0";
  input Real du_high "High integrand value";
  input Real du_low=0 "Low integrand value, default 0";
  output Real dintegral=0.0 "Integral of polynomial p from u_low to u_high";
algorithm
  dintegral := evaluate(p, u_high)*du_high;
end integralValue_der;
