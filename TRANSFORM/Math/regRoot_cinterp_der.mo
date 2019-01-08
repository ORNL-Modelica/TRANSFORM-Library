within TRANSFORM.Math;
function regRoot_cinterp_der
  extends TRANSFORM.Icons.Function;
  input Real x "Root argument";
  input Real deltax=0.01 "Interpolation interval near 0";
  input Real dx "Derivative of argument";
  output Real dy "Derivative of root";
protected
  Real C3;
  Real C1;
  Real deltax2;
  Real deltax_abs;
  Real sqrtdeltax;
algorithm
  // the derivative function here assumes that delta_x is constant
  deltax_abs := abs(deltax);
  if (x > deltax_abs) then
    // dy := -dx/(2*sqrt(x));
    dy := 1/2.*x^(-1/2)*dx;
  elseif (x < -deltax_abs) then
    //dy := -dx/(2*sqrt(-x));
    dy := 1/2.*(-x)^(-1/2)*dx;
  elseif (abs(x) <= 1.e-10) then
    dy := 0.0;
  else
    deltax2 := deltax_abs*deltax_abs;
    sqrtdeltax := sqrt(deltax_abs);
    C3 := -0.25/(sqrtdeltax*deltax2);
    C1 := 0.5/sqrtdeltax - 3.0*C3*deltax2;
    dy := dx*(C1 + 3*C3*x*x);
  end if;

end regRoot_cinterp_der;
