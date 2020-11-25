within TRANSFORM.Math.Scratch.Easing.Examples;
model EasingModel
  extends TRANSFORM.Icons.Example;

  Easing easing(
    pos=-3,
    neg=2,
    dt=2,
    offset=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end EasingModel;
