within TRANSFORM.Math.Examples;
model check_cspline "Test problem for cubic splines"
  extends TRANSFORM.Icons.Example;


  parameter Real[:] x={10,20,50,80,85,90} "Support points";
  parameter Real[size(x, 1)] y={11,15,-5,0,14,60} "Support points";

  // Get the derivative values at the support points
  final parameter Real[size(x, 1)] d=TRANSFORM.Math.splineDerivatives(
      x=x,
      y=y,
      ensureMonotonicity=false);

  Real z "Dependent variable without monotone interpolation";

  Utilities.ErrorAnalysis.UnitTests unitTests(x={z})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation
  z = TRANSFORM.Math.cspline(
    time,
    x,
    y,
    d);

  annotation (experiment(StopTime=100), Documentation(info="<html>
</html>"));
end check_cspline;
