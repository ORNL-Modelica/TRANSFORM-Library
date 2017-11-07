within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Examples;
model Plane_3D_Test
  extends Icons.Example;

  Plane_3D geometry(
    nX=3,
    nY=1,
    nZ=1,
    length_x=1,
    length_y=1,
    length_z=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Plane_3D_Test;
