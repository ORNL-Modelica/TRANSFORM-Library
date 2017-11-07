within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Examples;
model Cylinder_3D_Test
  extends Icons.Example;

  Cylinder_3D
           geometry(
    r_inner=0.01,
    r_outer=0.02,
    length_z=0.03,
    nR=4,
    nZ=3,
    nTheta=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder_3D_Test;
