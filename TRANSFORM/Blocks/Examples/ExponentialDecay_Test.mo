within TRANSFORM.Blocks.Examples;
model ExponentialDecay_Test
  extends TRANSFORM.Icons.Example;

  ExponentialDecay exponentialDecay(
    startTime=0.1,
    offset=5,
    frac=0.4,
    lambda=10)
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={exponentialDecay.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExponentialDecay_Test;
