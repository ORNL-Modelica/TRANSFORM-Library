within TRANSFORM.Math.Examples;
model check_cubicRoots
  extends TRANSFORM.Icons.Example;

  parameter Real a = 1;
  parameter Real b = -2;
  parameter Real c = -5;
  parameter Real d = -3;

 Complex[3] roots_c "Real roots";
 Real nRoots_c "Number of distinct real solutions expected";

 Real[3] roots "Real roots";
 Real nRoots "Number of distinct real solutions expected";

 Real root "Real root";

  Utilities.ErrorAnalysis.UnitTests unitTests(n=5, x=cat(
        1,
        {roots_c[2].im},
        {roots[1]},
        {roots[3]},
        {nRoots_c},
        {root}))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

(roots_c, nRoots_c) = TRANSFORM.Math.ComplexMath.ccubicRoots(a, b, c, d);

 (roots, nRoots) = cubicRoots_Real(a, b, c, d);

 root = cubicRoots_SingleReal(a, b, c, d,-10,10);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_cubicRoots;
