within TRANSFORM.Blocks.Examples;
model MFBS_Test
  extends TRANSFORM.Icons.Example;

  Noise.MFBS sequencer(
    startTime=0.5,
    offset=1,
    period=5) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={sequencer.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10));
end MFBS_Test;
