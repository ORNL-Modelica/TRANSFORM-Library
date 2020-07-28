within TRANSFORM.Blocks.Examples;
model Easing_Test
  extends TRANSFORM.Icons.Example;

  Blocks.Sources.Easing easing(
    pos=-3,
    neg=2,
    dt=2,
    offset=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Sources.Easing easing1(
    redeclare function Easing = Math.Easing.Cubic.easeOut,
    pos=-3,
    neg=2,
    dt=2,
    offset=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={easing.y,easing1.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end Easing_Test;
