within TRANSFORM.Math;
function regExponent_cinterp_der
  extends TRANSFORM.Icons.Function;
  input Real x "Root argument";
  input Real deltax=0.01 "Interpolation interval near 0";
  input Real z(max=3) = 0.5 "non-Integer exponent";
  input Real dx "Derivative of argument";
  output Real dy "Derivative of root";
protected
  Real C3;
  Real C1;
  Real deltax_abs;
algorithm
  // the derivative function here assumes that delta_x is constant
  deltax_abs := abs(deltax);
  if (x > deltax_abs) then
    dy := z.*x^(z-1)*dx;
  elseif (x < -deltax_abs) then
    dy := z.*(-x)^(z-1)*dx;
  else
    C1 := deltax_abs^(z - 1)*(3 - z)/2;
    C3 := deltax_abs^(z - 3)*(z - 1)/2;
    dy := dx*(C1 + 3*C3*x*x);
  end if;
end regExponent_cinterp_der;
