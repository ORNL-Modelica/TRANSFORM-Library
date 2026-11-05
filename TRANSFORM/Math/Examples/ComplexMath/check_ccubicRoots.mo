within TRANSFORM.Math.Examples.ComplexMath;
model check_ccubicRoots
  extends TRANSFORM.Icons.Example;
  parameter Real a = 1;
  parameter Real b = -2;
  parameter Real c = -5;
  parameter Real d = -3;
 Complex[3] roots "Real roots";
 Real nRoots "Number of distinct real solutions expected";
 Real roots_re[3] "Real parts of roots";
 Real roots_im[3] "Imaginary parts of roots";
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=cat(
        1,
        {roots[2].re},
        {roots[2].im}))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  // Through re and im, not (roots, nRoots) = ccubicRoots(...): OpenModelica 1.27.1 cannot set
  // a Complex array in a model from a function call (see ccubicRoots).
  (, nRoots, roots_re, roots_im) = TRANSFORM.Math.ComplexMath.ccubicRoots(a, b, c, d);
  roots = {Complex(roots_re[i], roots_im[i]) for i in 1:3};
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_ccubicRoots;
