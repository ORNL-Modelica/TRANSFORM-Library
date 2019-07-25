within TRANSFORM.Math;
function smoothMax_exponential
  extends TRANSFORM.Icons.Function;
  import Modelica.Math;
  input Real x1 "First argument of smooth max operator";
  input Real x2 "Second argument of smooth max operator";
  input Real dx
  "Approximate difference between x1 and x2, below which regularization starts";
  output Real y "Result of smooth max operator";
protected
  Real k = 4/dx;
algorithm
   y := max(x1, x2) + Math.log(exp(k*(x1 - max(x1, x2))) + exp(k*(x2 - max(x1, x2))))/k;
   annotation (smoothOrder=2,derivative=smoothMax_exponential_der, Documentation(info="<html>
<p>An implementation of Kreisselmeier Steinhauser smooth maximum. This does not return the exact value of x1 or x2, only an approximation, though the error diminishes as the transition region is exited.</p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/smoothMax.jpg\"/></p>
<p>Sources:</p>
<ul>
<li>https://www.johndcook.com/blog/2010/01/20/how-to-compute-the-soft-maximum/</li>
</ul>
</html>"));
end smoothMax_exponential;
