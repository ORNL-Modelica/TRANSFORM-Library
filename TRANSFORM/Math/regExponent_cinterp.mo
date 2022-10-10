within TRANSFORM.Math;
function regExponent_cinterp
 "Root function of exponent (x^z) with cubic interpolation near 0"
 extends TRANSFORM.Icons.Function;
 input Real x "Argument of root";
 input Real deltax=0.01 "Interpolation interval near 0";
 input Real z(max=3) = 0.5 "non-Integer exponent";
 output Real y "Root or regularized root near zero";
protected
 Real C3;
 Real C1;
 Real deltax_abs;
algorithm
 deltax_abs := abs(deltax);
 if (x > deltax_abs) then
   y := x^z;
 elseif (x < -deltax_abs) then
   y := -(-x)^z;
 else
   C1 := deltax_abs^(z - 1)*(3 - z)/2;
   C3 := deltax_abs^(z - 3)*(z - 1)/2;
   y := (C1 + C3*x*x)*x;
 end if;

  annotation (derivative(
      zeroDerivative=deltax,
      zeroDerivative=z) = regExponent_cinterp_der);
end regExponent_cinterp;
