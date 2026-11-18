within TRANSFORM.Math;
function besselI "Modified Bessel function of the first kind, integer order"
  extends TRANSFORM.Icons.Function;
  input Integer n "Order (n >= 0)";
  input Real x "Argument";
  output Real y "I_n(x)";
protected
  Real term "Current term of the series";
  Integer k "Index of the current term";
algorithm
  assert(n >= 0, "besselI: the order n must be >= 0");
  term := if n == 0 then 1 else (abs(x)/2)^n;
  for j in 1:n loop
    term := term/j;
  end for;
  y := term;
  k := 0;
  while abs(term) > 1e-17*abs(y) loop
    k := k + 1;
    term := term*(x/2)^2/(k*(k + n));
    y := y + term;
  end while;
  // I_n(-x) = (-1)^n*I_n(x)
  if x < 0 and mod(n, 2) == 1 then
    y := -y;
  end if;
  annotation (Documentation(info="<html>
<p>Returns the modified Bessel function of the first kind, I_n(x), for integer order n &ge; 0 and any real x, with I_n(-x) = (-1)^n I_n(x). It sums the power series (Abramowitz and Stegun, Handbook of Mathematical Functions, chapter 9, equation 9.6.10) until a term is below 1e-17 of the sum.</p>
</html>"));
end besselI;
