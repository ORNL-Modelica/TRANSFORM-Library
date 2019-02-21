within TRANSFORM.Math.Examples.ComplexMath;
model check_csqrt
  extends TRANSFORM.Icons.Example;
  parameter Real x = -5;
 Complex y;
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={y.re,y.im})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y = .TRANSFORM.Math.ComplexMath.csqrt(x);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_csqrt;
