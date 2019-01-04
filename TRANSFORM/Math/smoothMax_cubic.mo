within TRANSFORM.Math;
function smoothMax_cubic
  extends Modelica.Icons.Function;
  import Modelica.Math;

  input Real x1 "First argument of smooth operator";
  input Real x2 "Second argument of smooth operator";
  input Real dx
  "Approximate difference between x1 and x2, below which regularization starts";
  output Real y "Result of smooth operator";
protected
  Real k = dx;
  Real h;

algorithm

  h :=max(k - abs(x1 - x2), 0);

  y :=max(x1,x2) + h^3/(6*k^2);

   annotation (smoothOrder=2, Documentation(info="<html>
<p>An implementation of the smooth maximum using a cubic term approach.</p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/smoothMax.jpg\"/></p>
<p><br><br>Source:</p>
<ul>
<li><a href=\"http://iquilezles.org/www/articles/smin/smin.htm\">http://iquilezles.org/www/articles/smin/smin.htm</a> </li>
</ul>
</html>"));
end smoothMax_cubic;
