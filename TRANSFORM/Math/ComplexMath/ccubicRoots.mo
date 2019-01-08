within TRANSFORM.Math.ComplexMath;
function ccubicRoots
  "Analytical solution for the roots of a cubic equation (a*x^3+b*x^2+c*x+d=0)"
  //http://mathforcollege.com/nm/mws/gen/03nle/mws_gen_nle_bck_exactcubic.pdf

  import TRANSFORM.Math.ComplexMath.csqrt;
  import Modelica.ComplexMath.'abs';

  input Real a;
  input Real b;
  input Real c;
  input Real d;

  output Complex[3] roots "Real roots";
  output Real nRoots "Number of distinct real solutions expected";

protected
  Real eps = Modelica.Constants.eps;
  Real f, e, s, theta, r;
  Real D "polynomial discriminant";

  Complex w;
  Complex[3] z;
  Complex[3] y;

algorithm
 assert(abs(a)>0, "Cubic root solver cannot handle a=0 at this time");

  f :=1/a*(d + 2*b^3/(27*a^2) - b*c/(3*a));
  e :=1/a*(c - b^2/(3*a));
  s :=-e/3;
  D := (1/3*e)^3 + 0.25*f^2;

  if abs(D) > eps then
    if D > 0 then
      nRoots :=1;
    else
      nRoots :=3;
    end if;
  else
    nRoots :=2;
  end if;

  // Positive portion of w solution.
  // Negative and positive return identical solutions so only one is needed.
  w :=(-Complex(f,0) + csqrt(f^2 + 4*e^3/27))/2;

  if w.re < 0 then
      theta :=atan(w.im/w.re) + pi;
  else
      theta :=atan(w.im/w.re);
  end if;

  r :='abs'(w);

  z[1] :=Complex(r^(1/3)*cos(theta/3),r^(1/3)*sin(theta/3));
  z[2] :=Complex(r^(1/3)*cos((theta + 2*pi)/3),r^(1/3)*sin((theta + 2*pi)/3));
  z[3] :=Complex(r^(1/3)*cos((theta + 4*pi)/3),r^(1/3)*sin((theta + 4*pi)/3));

  for i in 1:3 loop

    y[i] :=z[i] + Complex(s,0)/z[i];

    // Values less than machine error are set to zero
    if abs(y[i].im) < eps then
      y[i].im :=0;
    end if;

    roots[i] :=y[i] - Complex(b/(3*a),0);

    // Values less than machine error are set to zero
    if abs(roots[i].re) < eps then
      roots[i].re :=0;
    end if;
  end for;

  annotation (Documentation(info="<html>
<p><br><span style=\"font-family: Courier New;\">Return roots[3] where each root is complex (i.e., has both roots[*].re and roots[*].im ).</span></p>
<p><br><span style=\"font-family: Courier New;\">nRoots helps to identify the number of expected real roots based on the result from the polynomial discriminant, D.</span></p>
</html>"));
end ccubicRoots;
