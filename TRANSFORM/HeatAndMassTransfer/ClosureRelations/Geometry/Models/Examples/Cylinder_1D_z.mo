within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Examples;
model Cylinder_1D_z
  import TRANSFORM;
  extends Icons.Example;
  constant Integer nZ = 2;
  constant SI.Length r_inner = 0 "Inner radius";
  constant SI.Length r_outer = 1 "Outer radius";
  constant SI.Angle angle_theta = Modelica.Constants.pi "Theta";
  constant SI.Length length_z = 1 "Z";
  TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_z
    geometry(
    r_inner=r_inner,
    r_outer=r_outer,
    angle_theta=angle_theta,
    nZ=nZ,
    length_z=length_z)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder_1D_z;
