within TRANSFORM.Math;
function besselJ
  extends TRANSFORM.Icons.Function;
  import gamma = TRANSFORM.Math.gamma_Lanczos;
  import TRANSFORM.Math.factorial;
  input Real k "Bessel order";
  input Real x "Value in Jk(x)";
  input Real tolerance = 1e-6 "tolerance for infinite sum termination";
  output Real Jk "Bessel function Jk(x) (order k) value";
protected
  Real eps = Modelica.Constants.eps*tolerance;
  Real sum_new, sum_old;
  Real nu = if k < 0 then -k else k;
  Integer n "Number of values inluded in infinite sum";
  Real err;
  constant Real bigNo = 1e10 "Rescaling threshold of the downward recurrence";
  Integer m "Integer order |k|";
  Integer mStart "Start order of the downward recurrence";
  Real ax "|x|";
  Real t "Polynomial variable";
  Real f "Modulus f_0 or f_1";
  Real theta "Phase theta_0 or theta_1";
  Real J_m "J of order j-1 (upward) or j+1 (downward)";
  Real J_j "J of order j";
  Real J_p "J of order j+1 (upward) or j-1 (downward)";
  Real J_n "Unnormalised J of order m (downward)";
  Real J_sum "Unnormalised sum of J of even order (downward)";
algorithm
  if k == floor(k) then
    // Integer order
    m := integer(abs(k));
    ax := abs(x);
    if ax == 0 then
      Jk := if m == 0 then 1.0 else 0.0;
    elseif m <= 1 or ax > m then
      if ax <= 3 then
        t := (ax/3)^2;
        // J0 and J1: Abramowitz and Stegun 9.4.1 and 9.4.4
        J_m := 1 + t*(-2.2499997 + t*(1.2656208 + t*(-0.3163866 + t*(0.0444479
           + t*(-0.0039444 + t*0.0002100)))));
        J_j := ax*(0.5 + t*(-0.56249985 + t*(0.21093573 + t*(-0.03954289 + t*(
          0.00443319 + t*(-0.00031761 + t*0.00001109))))));
      else
        t := 3/ax;
        // J0 and J1: Abramowitz and Stegun 9.4.3 and 9.4.6
        f := 0.79788456 + t*(-0.00000077 + t*(-0.00552740 + t*(-0.00009512 + t*(
          0.00137237 + t*(-0.00072805 + t*0.00014476)))));
        theta := ax - 0.78539816 + t*(-0.04166397 + t*(-0.00003954 + t*(
          0.00262573 + t*(-0.00054125 + t*(-0.00029333 + t*0.00013558)))));
        J_m := f*cos(theta)/sqrt(ax);
        f := 0.79788456 + t*(0.00000156 + t*(0.01659667 + t*(0.00017105 + t*(-0.00249511
           + t*(0.00113653 + t*(-0.00020033))))));
        theta := ax - 2.35619449 + t*(0.12499612 + t*(0.00005650 + t*(-0.00637879
           + t*(0.00074348 + t*(0.00079824 + t*(-0.00029166))))));
        J_j := f*cos(theta)/sqrt(ax);
      end if;
      // Upward recurrence J_(j+1) = 2*j/x*J_j - J_(j-1), stable for x > order
      if m == 0 then
        Jk := J_m;
      else
        for j in 1:m - 1 loop
          J_p := 2*j/ax*J_j - J_m;
          J_m := J_j;
          J_j := J_p;
        end for;
        Jk := J_j;
      end if;
    else
      // Miller's downward recurrence J_(j-1) = 2*j/x*J_j - J_(j+1), started
      // well above the order and normalised by J_0 + 2*sum(J_2k) = 1
      mStart := 2*div(m + integer(sqrt(160*m)), 2);
      J_m := 0;
      J_j := 1;
      J_n := 0;
      J_sum := 0;
      for j in mStart:-1:1 loop
        J_p := 2*j/ax*J_j - J_m;
        J_m := J_j;
        J_j := J_p;
        if abs(J_j) > bigNo then
          J_j := J_j/bigNo;
          J_m := J_m/bigNo;
          J_n := J_n/bigNo;
          J_sum := J_sum/bigNo;
        end if;
        if mod(j, 2) == 1 then
          J_sum := J_sum + J_j;
        end if;
        if j == m then
          J_n := J_m;
        end if;
      end for;
      Jk := J_n/(2*J_sum - J_j);
    end if;
    // J_n(-x) = (-1)^n J_n(x) and J_(-n)(x) = (-1)^n J_n(x)
    if mod(m, 2) == 1 and (x < 0 and k >= 0 or x >= 0 and k < 0) then
      Jk := -Jk;
    end if;
  else
    // Non-integer order: power series
    sum_old := 0;
    n :=0;
    err :=100;
    while err >= tolerance and n <=1e3 loop
      sum_new :=sum_old + (-0.25*x^2)^n/(factorial(n)*gamma(nu + n + 1));
      err :=abs(sum_new - sum_old);
      n := n + 1;
      sum_old :=sum_new;
    end while;
    assert(n<=1e3, "Maximum number of iterations reached in BesselJ. Relax tolerance or check input values");
    if k < 0 then
      Jk := (-1)^nu*(0.5*x)^nu*sum_new;
    elseif k == 0 and x == 0 then
      Jk := 1.0;
    else
      Jk :=(0.5*x)^nu*sum_new;
    end if;
  end if;
  annotation (Documentation(info="<html>
<p>Returns the Bessel function of the first kind, J_k(x). For integer order n it takes J_0 and J_1 from the polynomial approximations of Abramowitz and Stegun, Handbook of Mathematical Functions, chapter 9 (equations 9.4.1 and 9.4.4 for |x| &le; 3, 9.4.3 and 9.4.6 for |x| &gt; 3), higher orders from the upward recurrence 9.1.27 when |x| &gt; n and otherwise from Miller's downward recurrence normalised by 9.1.46 (J_0 + 2 &Sigma; J_2k = 1), with J_n(-x) = J_(-n)(x) = (-1)^n J_n(x); for non-integer order k it sums the power series 9.1.10 until a term is below <code>tolerance</code>, which applies only to non-integer order.</p>
<p>See <a href=\"http://mathworld.wolfram.com/BesselFunctionoftheFirstKind.html\">http://mathworld.wolfram.com/BesselFunctionoftheFirstKind.html</a> for more details.</p>
</html>"));
end besselJ;
