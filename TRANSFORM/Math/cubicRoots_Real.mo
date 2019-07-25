within TRANSFORM.Math;
function cubicRoots_Real
  "Analytical solution for the real roots of a cubic equation (a*x^3+b*x^2+c*x+d=0)"
  //http://mathworld.wolfram.com/CubicFormula.html
  input Real a;
  input Real b;
  input Real c;
  input Real d;
  output Real[3] roots "Real roots";
  output Real nRoots "Number of distinct real solutions expected";
protected
  Real eps = Modelica.Constants.eps;
  Complex[3] cRoots;
algorithm
  (cRoots,nRoots) :=TRANSFORM.Math.ComplexMath.ccubicRoots(
    a=a,
    b=b,
    c=c,
    d=d);
  if nRoots == 1 then
    // Extract real roots based on a real solution should have an imaginary part
    // of 0 (within machine precision). Other roots get assigned a arbitrary
    // value for differentiation.
    for i in 1:3 loop
      if abs(cRoots[i].im) < eps then
        roots[i] :=cRoots[i].re;
      else
        roots[i] :=999;
      end if;
    end for;
  else
    // When nRoots = 2, two of the roots will be the same and all are real.
    for i in 1:3 loop
      roots[i] :=cRoots[i].re;
    end for;
  end if;
  annotation (Documentation(info="<html>
<p>Uses ccubicRoots but only returns on the real portion of the roots (i.e., roots[*] = Real). If a root has a imaginary portion greater than machine tolerance than a dummy value is returned for that root.</p>
<p>nRoots helps to identify the number of expected real roots based on the result from the polynomial discriminant, D.</p>
</html>"));
end cubicRoots_Real;
