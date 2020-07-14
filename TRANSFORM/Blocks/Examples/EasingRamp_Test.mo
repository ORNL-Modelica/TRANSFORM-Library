within TRANSFORM.Blocks.Examples;
model EasingRamp_Test
  extends TRANSFORM.Icons.Example;

   Utilities.ErrorAnalysis.UnitTests unitTests(x={easingRamp.y})
     annotation (Placement(transformation(extent={{80,80},{100,100}})));
   Sources.EasingRamp easingRamp(
     duration=0.5,
     offset=1,
     startTime=0.25)
     annotation (Placement(transformation(extent={{-10,-10},{10,10}})));


  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5, __Dymola_Algorithm="Dassl"));
end EasingRamp_Test;
