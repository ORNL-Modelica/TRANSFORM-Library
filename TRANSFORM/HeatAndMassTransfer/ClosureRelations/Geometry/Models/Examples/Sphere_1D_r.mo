within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Examples;
model Sphere_1D_r

  extends Icons.Example;

  constant Integer nR = 2;
  constant SI.Length r_inner = 0 "Inner radius";
  constant SI.Length r_outer = 1 "Outer radius";
  constant SI.Angle angle_theta = Modelica.Constants.pi "Theta";
  constant SI.Angle angle_phi = 0.5*Modelica.Constants.pi "Phi";

  TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Sphere_1D_r geometry(
    r_inner=r_inner,
    r_outer=r_outer,
    angle_theta=angle_theta,
    angle_phi=angle_phi,
    nR=nR) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end Sphere_1D_r;
