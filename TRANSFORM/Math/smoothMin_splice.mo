within TRANSFORM.Math;
function smoothMin_splice
  "Once continuously differentiable approximation to the minimum function using a splice function"
  extends TRANSFORM.Icons.Function;
  input Real x1 "First argument";
  input Real x2 "Second argument";
  input Real dx "Width of transition interval";
  output Real y "Result";
algorithm
  y := spliceTanh(
       pos=x1, neg=x2, x=x2-x1, deltax=dx);
  annotation (smoothOrder=1,
Documentation(info="<html>
<p>Once continuously differentiable approximation to the <span style=\"font-family: Courier New;\">min(.,.)</span> function. </p>
<p>Note that the minimum need not be respected.</p>
<p><br><span style=\"font-family: Courier New;\">Adapted&nbsp;from&nbsp;Buildings&nbsp;Library</span></p>
</html>"));
end smoothMin_splice;
