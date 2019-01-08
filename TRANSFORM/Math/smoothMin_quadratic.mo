within TRANSFORM.Math;
function smoothMin_quadratic
  extends TRANSFORM.Icons.Function;
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

  y :=min(x1,x2) - h^2/(4*k);

   annotation (smoothOrder=1, Documentation(info="<html>
<p>An implementation of the smooth minimum using a quadratic term approach.</p>
<p><br><br>Source:</p>
<ul>
<li><a href=\"http://iquilezles.org/www/articles/smin/smin.htm\">http://iquilezles.org/www/articles/smin/smin.htm</a> </li>
</ul>
</html>"));
end smoothMin_quadratic;
