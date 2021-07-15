within TRANSFORM.Math;
function quadratic "A quadratic function"
  extends TRANSFORM.Icons.Function;
  input Real a "2nd order coefficient";
  input Real b "1st order coefficient";
  input Real c "constant term";
  input Real x "independent variable";
  output Real y "dependent variable";
algorithm

   y := a*x*x + b*x + c;

  annotation(inverse(x = InverseQuadratic(a,b,c,y)),
              Documentation(info="<html>
<p>A basic quadratic function</p>
<p>Source:</p>
<p>- https://mbe.modelica.university/behavior/functions/nonlinear/</p>
</html>"));
end quadratic;
