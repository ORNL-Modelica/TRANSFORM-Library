within TRANSFORM.Math;
function besselY "Bessel function of the second kind, integer order"
  extends TRANSFORM.Icons.Function;
  input Integer n "Order (n >= 0)";
  input Real x "Argument (x > 0)";
  output Real y "Y_n(x)";
protected
  constant Real pi = Modelica.Constants.pi;
  Real t "Polynomial variable";
  Real J0 "J_0(x)";
  Real J1 "J_1(x)";
  Real f "Modulus f_0 or f_1";
  Real theta "Phase theta_0 or theta_1";
  Real Y_m "Y of order j-1";
  Real Y_j "Y of order j";
  Real Y_p "Y of order j+1";
algorithm
  assert(n >= 0, "besselY: the order n must be >= 0");
  assert(x > 0, "besselY: the argument x must be > 0");
  if x <= 3 then
    t := (x/3)^2;
    // J0 and J1: Abramowitz and Stegun 9.4.1 and 9.4.4
    J0 := 1 + t*(-2.2499997 + t*(1.2656208 + t*(-0.3163866 + t*(0.0444479
       + t*(-0.0039444 + t*0.0002100)))));
    J1 := x*(0.5 + t*(-0.56249985 + t*(0.21093573 + t*(-0.03954289 + t*(
      0.00443319 + t*(-0.00031761 + t*0.00001109))))));
    // Y0 and Y1: Abramowitz and Stegun 9.4.2 and 9.4.5
    Y_m := 2/pi*log(x/2)*J0 + (0.36746691 + t*(0.60559366 + t*(-0.74350384
       + t*(0.25300117 + t*(-0.04261214 + t*(0.00427916 + t*(-0.00024846)))))));
    Y_j := 2/pi*log(x/2)*J1 + (-0.6366198 + t*(0.2212091 + t*(2.1682709 + t
      *(-1.3164827 + t*(0.3123951 + t*(-0.0400976 + t*0.0027873))))))/x;
  else
    t := 3/x;
    // Y0 and Y1: Abramowitz and Stegun 9.4.3 and 9.4.6
    f := 0.79788456 + t*(-0.00000077 + t*(-0.00552740 + t*(-0.00009512 + t*(
      0.00137237 + t*(-0.00072805 + t*0.00014476)))));
    theta := x - 0.78539816 + t*(-0.04166397 + t*(-0.00003954 + t*(
      0.00262573 + t*(-0.00054125 + t*(-0.00029333 + t*0.00013558)))));
    Y_m := f*sin(theta)/sqrt(x);
    f := 0.79788456 + t*(0.00000156 + t*(0.01659667 + t*(0.00017105 + t*(-0.00249511
       + t*(0.00113653 + t*(-0.00020033))))));
    theta := x - 2.35619449 + t*(0.12499612 + t*(0.00005650 + t*(-0.00637879
       + t*(0.00074348 + t*(0.00079824 + t*(-0.00029166))))));
    Y_j := f*sin(theta)/sqrt(x);
  end if;
  // Upward recurrence Y_(j+1) = 2*j/x*Y_j - Y_(j-1)
  if n == 0 then
    y := Y_m;
  else
    for j in 1:n - 1 loop
      Y_p := 2*j/x*Y_j - Y_m;
      Y_m := Y_j;
      Y_j := Y_p;
    end for;
    y := Y_j;
  end if;
  annotation (Documentation(info="<html>
<p>Returns the Bessel function of the second kind, Y_n(x), for integer order n &ge; 0 and x &gt; 0. Y_0 and Y_1 come from the polynomial approximations of Abramowitz and Stegun, Handbook of Mathematical Functions, chapter 9, equations 9.4.1, 9.4.2, 9.4.4 and 9.4.5 for x &le; 3 and 9.4.3 and 9.4.6 for x &gt; 3, and higher orders from the upward recurrence Y_(n+1) = 2n/x Y_n - Y_(n-1).</p>
</html>"));
end besselY;
