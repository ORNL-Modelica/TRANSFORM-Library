within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_2D_r_z
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nR,nZ}, final figure=2);
  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";

  //todo: make r_inner rs_inner? allow cylinder of different geoemtry on inner surface. Already permitted on outer surface... Do for all cylinder and sphere geometries.. 1D and 3D as well?
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
  input SI.Length length_z=1 "Specify overall length or dzs in z-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length drs[nR,nZ](each min=0) = fill(
    (r_outer - r_inner)/nR,
    nR,
    nZ) "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nR,nZ](each min=0) = fill(
    angle_theta,
    nR,
    nZ) "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nR,nZ](each min=0) = fill(
    (length_z)/nZ,
    nR,
    nZ) "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));
  SI.Length rs[nR,nZ] "Position in r-dimension";
  SI.Angle thetas[nR,nZ] "Position in theta-dimension";
  SI.Length zs[nR,nZ] "Position in z-dimension";
initial equation
  closedDim_1 = fill(false,nZ);
  closedDim_2 = fill(false,nR);
algorithm
  for k in 1:nZ loop
    rs[1, k] := r_inner + 0.5*drs[1, k];
    for i in 2:nR loop
      rs[i, k] := r_inner + sum(drs[1:i - 1, k]) + 0.5*drs[i, k];
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      thetas[i, k] := 0.5*dthetas[i, k];
    end for;
  end for;
  for i in 1:nR loop
    zs[i, 1] := 0.5*dzs[i, 1];
    for k in 2:nZ loop
      zs[i, k] := sum(dzs[i, 1:k - 1]) + 0.5*dzs[i, k];
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      Vs[i, k] := 0.5*((rs[i, k] + 0.5*drs[i, k])^2 - (rs[i, k] - 0.5*drs[i, k])
        ^2)*dthetas[i, k]*dzs[i, k];
    end for;
  end for;
  for k in 1:nZ loop
    for i in 1:nR loop
      crossAreas_1[i, k] := (rs[i, k] - 0.5*drs[i, k])*dthetas[i, k]*dzs[i, k];
    end for;
    crossAreas_1[nR + 1, k] := (rs[nR, k] + 0.5*drs[nR, k])*dthetas[nR, k]*dzs[
      nR, k];
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      crossAreas_2[i, k] := 0.5*((rs[i, k] + 0.5*drs[i, k])^2 - (rs[i, k] - 0.5
        *drs[i, k])^2)*dthetas[i, k];
    end for;
    crossAreas_2[i, nZ + 1] := 0.5*((rs[i, nZ] + 0.5*drs[i, nZ])^2 - (rs[i, nZ]
       - 0.5*drs[i, nZ])^2)*dthetas[i, nZ];
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      dlengths_1[i, k] := drs[i, k];
      dlengths_2[i, k] := dzs[i, k];
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      cs_1[i, k] := rs[i, k]*Modelica.Math.cos(thetas[i, k]);
      cs_2[i, k] := zs[i, k];
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      if dthetas[i, k] < 2*Modelica.Constants.pi then
        surfaceAreas_3a[i, k] := drs[i, k]*dzs[i, k];
        surfaceAreas_3b[i, k] := drs[i, k]*dzs[i, k];
      else
        surfaceAreas_3a[i, k] := 0;
        surfaceAreas_3b[i, k] := 0;
      end if;
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_2D_r_z;
