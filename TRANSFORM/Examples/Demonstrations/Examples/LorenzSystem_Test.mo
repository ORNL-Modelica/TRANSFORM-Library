within TRANSFORM.Examples.Demonstrations.Examples;
model LorenzSystem_Test
  import TRANSFORM;
  extends Icons.Example;
  parameter Real sigma=10;
  parameter Real rho=28;
  parameter Real beta=8/3;
  TRANSFORM.Examples.Demonstrations.Models.LorenzSystem lorenzSystem(
    x_start=0,
    y_start=1,
    z_start=1.05,
    sigma=sigma,
    rho=rho,
    beta=beta)
    annotation (Placement(transformation(extent={{-40,-30},{40,30}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(
    printResult=false,
    n=3,
    x={lorenzSystem.x,lorenzSystem.y,lorenzSystem.z})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=10000));
end LorenzSystem_Test;
