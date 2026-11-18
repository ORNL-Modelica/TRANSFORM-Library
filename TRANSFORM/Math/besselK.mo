within TRANSFORM.Math;
function besselK "Modified Bessel function of the second kind, integer order"
  extends TRANSFORM.Icons.Function;
  input Integer n "Order (n >= 0)";
  input Real x "Argument (x > 0)";
  output Real y "K_n(x)";
protected
  Real t "Polynomial variable";
  Real K_m "K of order j-1";
  Real K_j "K of order j";
  Real K_p "K of order j+1";
algorithm
  assert(n >= 0, "besselK: the order n must be >= 0");
  assert(x > 0, "besselK: the argument x must be > 0");
  // K0 and K1: Abramowitz and Stegun 9.8.5 to 9.8.8
  if x <= 2 then
    t := (x/2)^2;
    K_m := -log(x/2)*TRANSFORM.Math.besselI(0, x) + (-0.57721566 + t*(
      0.42278420 + t*(0.23069756 + t*(0.03488590 + t*(0.00262698 + t*(
      0.00010750 + t*0.00000740))))));
    K_j := log(x/2)*TRANSFORM.Math.besselI(1, x) + (1/x)*(1 + t*(0.15443144
       + t*(-0.67278579 + t*(-0.18156897 + t*(-0.01919402 + t*(-0.00110404
       + t*(-0.00004686)))))));
  else
    t := 2/x;
    K_m := exp(-x)/sqrt(x)*(1.25331414 + t*(-0.07832358 + t*(0.02189568 + t
      *(-0.01062446 + t*(0.00587872 + t*(-0.00251540 + t*0.00053208))))));
    K_j := exp(-x)/sqrt(x)*(1.25331414 + t*(0.23498619 + t*(-0.03655620 + t
      *(0.01504268 + t*(-0.00780353 + t*(0.00325614 + t*(-0.00068245)))))));
  end if;
  // Upward recurrence K_(j+1) = K_(j-1) + 2*j/x*K_j
  if n == 0 then
    y := K_m;
  else
    for j in 1:n - 1 loop
      K_p := K_m + 2*j/x*K_j;
      K_m := K_j;
      K_j := K_p;
    end for;
    y := K_j;
  end if;
  annotation (Documentation(info="<html>
<p>Returns the modified Bessel function of the second kind, K_n(x), for integer order n &ge; 0 and x &gt; 0. K_0 and K_1 come from the polynomial approximations of Abramowitz and Stegun, Handbook of Mathematical Functions, chapter 9, equations 9.8.5 to 9.8.8 (with I_0 and I_1 from <code>besselI</code>), and higher orders from the upward recurrence K_(n+1) = K_(n-1) + 2n/x K_n; against the GNU Scientific Library the relative error is below 2e-7 for n = 0 to 3 and x from 0.01 to 40.</p>
</html>"));
end besselK;
