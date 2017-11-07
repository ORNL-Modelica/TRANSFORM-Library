within TRANSFORM.Math;
function regRoot_cinterp "Square root function with cubic interpolation near 0"
  extends Modelica.Icons.Function;
  input Real x "Argument of root";
  input Real deltax=0.01 "Interpolation interval near 0";
  output Real y "Root or regularized root near zero";

protected
  Real C3;
  Real C1;
  Real deltax2;
  Real deltax_abs;
  Real sqrtdeltax;
algorithm
  deltax_abs := abs(deltax);
  if (x > deltax_abs) then
    y := sqrt(x);
  elseif (x < -deltax_abs) then
    y := -sqrt(-x);
  elseif (abs(x) <= 0.0) then
    y := 0.0;
  else
    deltax2 := deltax_abs*deltax_abs;
    sqrtdeltax := sqrt(deltax_abs);
    C3 := -0.25/(sqrtdeltax*deltax2);
    C1 := 0.5/sqrtdeltax - 3.0*C3*deltax2;
    y := (C1 + C3*x*x)*x;
  end if;
annotation(derivative(zeroDerivative=deltax) = regRoot_cinterp_der);
end regRoot_cinterp;
