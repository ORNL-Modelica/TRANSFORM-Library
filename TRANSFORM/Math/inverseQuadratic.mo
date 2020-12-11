within TRANSFORM.Math;
function inverseQuadratic
  "An inverse quadratic function that only returns one root"
  extends TRANSFORM.Icons.Function;
  input Real a;
  input Real b;
  input Real c;
  input Real y;
  output Real x;
algorithm
  x := (-b+sqrt(b*b - 4*a*(c-y)))/(2*a);

  annotation(Documentation(info="<html>
<p>A basic inverse quadratic function</p>
<p>Source:</p>
<p>- https://mbe.modelica.university/behavior/functions/nonlinear/</p>
</html>"));
end inverseQuadratic;
