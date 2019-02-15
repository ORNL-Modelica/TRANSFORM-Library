within TRANSFORM.Math.Examples;
model check_integral_TrapezoidalRule
  extends TRANSFORM.Icons.Example;
parameter Real x[:] = {2.1,2.4,2.7,3.0,3.3,3.6};
parameter Real z[size(x,1)] = {3.2,2.7,2.9,3.5,4.1,5.2};
Real y = TRANSFORM.Math.integral_TrapezoidalRule(x,z);
  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end check_integral_TrapezoidalRule;
