within TRANSFORM.Math;
function psi "Psi or digamma function: d(gamma)/dx/gamma"
  extends TRANSFORM.Icons.Function;
  input Real x "Input value";
  input Integer nk=10 "Number of summations";
  output Real psi "psi function value";

protected
  Real gamma=0.57721566490153286060;
  Real sum=0.0;
  Integer k;

algorithm

  for i in 1:nk + 1 loop
    k := i - 1;
    if abs(x + k) <= Modelica.Constants.eps then
      sum := Modelica.Constants.inf;
    else
      sum := sum + (1/(x + k) - 1/(k + 1));
    end if;
  end for;

  psi := -gamma - sum;

  annotation (Documentation(info="<html>
<p>Implementation of the psi or digamma function. See also scipy.special.psi or scipy.special.digamma</p>
<p>Source:</p>
<p> - http://scipp.ucsc.edu/~haber/ph116A/psifun_11.pdf</p>
<p>- NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY, <i>NIST handbook of mathematical functions</i>, F. W. J. Olver et al., Eds., Cambridge University Press, Cambridge New York Melbourne (2010). </p>
</html>"));
end psi;
