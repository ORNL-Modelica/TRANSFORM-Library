within TRANSFORM.Examples.Demonstrations.Examples;
model LorenzSystem_Test

  extends Icons.Example;

  TRANSFORM.Examples.Demonstrations.Models.LorenzSystem lorenzSystem(
    sigma=10,
    rho=28,
    beta=8/3,
    x_start=0,
    y_start=1,
    z_start=1.05)
    annotation (Placement(transformation(extent={{-40,-30},{40,30}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=10000));
end LorenzSystem_Test;
