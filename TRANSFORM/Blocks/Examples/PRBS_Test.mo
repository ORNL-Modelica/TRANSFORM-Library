within TRANSFORM.Blocks.Examples;
model PRBS_Test
  extends TRANSFORM.Icons.Example;

  TRANSFORM.Blocks.Noise.PRBS sequencer(
    freqHz=10,
    offset=1,
    startTime=0.5)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={sequencer.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10));
end PRBS_Test;
