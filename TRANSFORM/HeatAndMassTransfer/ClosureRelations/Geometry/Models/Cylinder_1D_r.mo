within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_1D_r
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nR}, final figure=2);
  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
  input SI.Length r_inner=0
    "Specify inner radius or dthetas in r-dimension and r_outer"
    annotation (Dialog(group="Inputs"));
  input SI.Length r_outer=1 "Specify outer radius or dthetas in r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle angle_theta(
    min=0,
    max=2*Modelica.Constants.pi) = 2*Modelica.Constants.pi
    "Specify angle or dthetas in theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length length_z=1 "Specify length or dzs in z-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length drs[nR](min=0) = fill((r_outer - r_inner)/nR, nR)
    "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nR](min=0) = fill(angle_theta, nR)
    "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nR](min=0) = fill(length_z, nR)
    "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));
  SI.Length rs[nR] "Position in r-dimension";
  SI.Angle thetas[nR] "Position in theta-dimension";
  SI.Length zs[nR] "Position in z-dimension";
initial equation
  closedDim_1 = false;
algorithm
  rs[1] := r_inner + 0.5*drs[1];
  for i in 2:nR loop
    rs[i] := r_inner + sum(drs[1:i - 1]) + 0.5*drs[i];
  end for;
  for i in 1:nR loop
    thetas[i] := 0.5*dthetas[i];
  end for;
  for i in 1:nR loop
    zs[i] := 0.5*dzs[i];
  end for;
  for i in 1:nR loop
    Vs[i] := 0.5*((rs[i] + 0.5*drs[i])^2 - (rs[i] - 0.5*drs[i])^2)*dthetas[i]*
      dzs[i];
  end for;
  for i in 1:nR loop
    crossAreas_1[i] := (rs[i] - 0.5*drs[i])*dthetas[i]*dzs[i];
  end for;
  crossAreas_1[nR + 1] := (rs[nR] + 0.5*drs[nR])*dthetas[nR]*dzs[nR];
  for i in 1:nR loop
    dlengths_1[i] := drs[i];
  end for;
  for i in 1:nR loop
    cs_1[i] := rs[i]*Modelica.Math.cos(thetas[i]);
  end for;
  for i in 1:nR loop
    if dthetas[i] < 2*Modelica.Constants.pi then
      surfaceAreas_2a[i] := drs[i]*dzs[i];
      surfaceAreas_2b[i] := drs[i]*dzs[i];
    else
      surfaceAreas_2a[i] := 0;
      surfaceAreas_2b[i] := 0;
    end if;
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
end Cylinder_1D_r;
