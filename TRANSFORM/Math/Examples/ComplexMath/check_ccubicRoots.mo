within TRANSFORM.Math.Examples.ComplexMath;
model check_ccubicRoots
  extends TRANSFORM.Icons.Example;

  parameter Real a = 1;
  parameter Real b = -2;
  parameter Real c = -5;
  parameter Real d = -3;

 Complex[3] roots "Real roots";
 Real nRoots "Number of distinct real solutions expected";

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=cat(
        1,
        {roots[2].re},
        {roots[2].im}))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

(roots, nRoots) = TRANSFORM.Math.ComplexMath.ccubicRoots(a, b, c, d);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_ccubicRoots;
