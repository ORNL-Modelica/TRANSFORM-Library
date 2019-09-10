within TRANSFORM.Math.Scratch;
function test3
  extends TRANSFORM.Icons.Function;

  input Real P[4] "Control points of bezier curve";
  input Real t "Function argument";

  output Real y;

algorithm

  y :=(1 - t)^2*P[1] + 2*(1 - t)*t*P[2] + t^2*P[3];

  annotation (smoothOrder=4, Documentation(info="<html>
<p>Implementation of the psi or digamma function. See also scipy.special.psi or scipy.special.digamma</p>
<p>Source:</p>
<p> - http://scipp.ucsc.edu/~haber/ph116A/psifun_11.pdf</p>
<p>- NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY, <i>NIST handbook of mathematical functions</i>, F. W. J. Olver et al., Eds., Cambridge University Press, Cambridge New York Melbourne (2010). </p>
</html>"));
end test3;
