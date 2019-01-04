within TRANSFORM.Math;
function smoothMin_exponential
  extends Modelica.Icons.Function;
  import Modelica.Math;

  input Real x1 "First argument of smooth operator";
  input Real x2 "Second argument of smooth operator";
  input Real dx
    "Approximate difference between x1 and x2, below which regularization starts";
  output Real y "Result of smooth operator";

protected
  Real k=4/dx;

algorithm

  // Original form
  //   y :=-log(exp(-k*min(x1, x2)) + exp(-k*max(x1, x2)))/k;

  y := min(x1, x2) - log(exp(-k*(x1 - min(x1, x2))) + exp(-k*(x2 - min(x1, x2))))/k;


  annotation (smoothOrder=4, Documentation(info="<html>
<p>An implementation of the smooth minimum using an exponential term approach. This does not return the exact value of x1 or x2, only an approximation, though the error diminishes as the transition region is exited.</p>
<p><br>Adapted to avoid underflow and overflow for large values of x1 and/or x2.</p>
<p><br>Source:</p>
<ul>
<li><a href=\"http://iquilezles.org/www/articles/smin/smin.htm\">http://iquilezles.org/www/articles/smin/smin.htm</a> </li>
<li>https://www.johndcook.com/blog/2010/01/20/how-to-compute-the-soft-maximum/</li>
</ul>
</html>"));
end smoothMin_exponential;
