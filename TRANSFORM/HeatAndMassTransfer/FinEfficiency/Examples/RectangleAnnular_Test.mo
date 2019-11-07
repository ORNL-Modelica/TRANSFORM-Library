within TRANSFORM.HeatAndMassTransfer.FinEfficiency.Examples;
model RectangleAnnular_Test
  extends TRANSFORM.Icons.Example;

  RectangleAnnular
             rectangleAnnular(
    alpha=100,
    lambda=5,
    r_inner=0.01,
    r_outer=0.05,
    th=0.01,
    pitch=0.0001)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RectangleAnnular_Test;
