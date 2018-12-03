within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_1D_theta

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nTheta}, final figure=2);

  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";

  input SI.Length r_inner=0
    "Specify inner radius or dthetas in r-dimension and r_outer"
    annotation (Dialog(group="Inputs"));
  input SI.Length r_outer=1 "Specify outer radius or dthetas in r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle angle_theta(
    min=0,
    max=2*Modelica.Constants.pi) = 2*Modelica.Constants.pi
    "Specify overall angle or dthetas in theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length length_z=1 "Specify length or dzs in z-dimension"
    annotation (Dialog(group="Inputs"));

  input SI.Length drs[nTheta](min=0) = fill(r_outer - r_inner, nTheta)
    "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nTheta](min=0) = fill(angle_theta/nTheta, nTheta)
    "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nTheta](min=0) = fill(length_z, nTheta)
    "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nTheta] "Position in r-dimension";
  SI.Angle thetas[nTheta] "Position in theta-dimension";
  SI.Length zs[nTheta] "Position in z-dimension";

initial equation
  if abs(sum(dthetas) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
    closedDim_1 = true;
  else
    closedDim_1 = false;
  end if;

equation

algorithm
  for j in 1:nTheta loop
    rs[j] := r_inner + 0.5*drs[j];
  end for;

  thetas[1] := 0.5*dthetas[1];
  for j in 2:nTheta loop
    thetas[j] := sum(dthetas[1:j - 1]) + 0.5*dthetas[j];
  end for;

  for j in 1:nTheta loop
    zs[j] := 0.5*dzs[j];
  end for;

  for j in 1:nTheta loop
    Vs[j] := 0.5*((rs[j] + 0.5*drs[j])^2 - (rs[j] - 0.5*drs[j])^2)*dthetas[j]*
      dzs[j];
  end for;

  for j in 1:nTheta loop
    crossAreas_1[j] := drs[j]*dzs[j];
  end for;
  crossAreas_1[nTheta + 1] := drs[nTheta]*dzs[nTheta];

  for j in 1:nTheta loop
    dlengths_1[j] := rs[j]*dthetas[j];
  end for;

  for j in 1:nTheta loop
    cs_1[j] := rs[j]*Modelica.Math.sin(thetas[j]);
  end for;

  for i in 1:nTheta loop
    surfaceAreas_2a[i] := r_inner*dthetas[i]*dzs[i];
    surfaceAreas_2b[i] := (r_inner + drs[i])*dthetas[i]*dzs[i];

    if i == 1 then
      surfaceAreas_3a[i] := ((r_inner + 0.5*drs[i])^2 - r_inner^2)*dthetas[i];
      surfaceAreas_3b[i] := ((r_inner + 0.5*drs[i])^2 - r_inner^2)*dthetas[i];
    else
      surfaceAreas_3a[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
        r_inner + sum(drs[1:i - 1]) - 0.5*drs[i - 1])^2)*dthetas[i];
      surfaceAreas_3b[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
        r_inner + sum(drs[1:i - 1]) - 0.5*drs[i - 1])^2)*dthetas[i];
    end if;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_1D_theta;
