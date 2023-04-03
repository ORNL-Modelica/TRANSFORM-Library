within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_2D_theta_z
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nTheta,nZ}, final figure=2);
  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";
  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";
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
  input SI.Length length_z=1 "Specify overall length or dzs in z-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length drs[nTheta,nZ](min=0) = fill(
    r_outer - r_inner,
    nTheta,
    nZ) "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nTheta,nZ](min=0) = fill(
    angle_theta/nTheta,
    nTheta,
    nZ) "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nTheta,nZ](min=0) = fill(
    (length_z)/nZ,
    nTheta,
    nZ) "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));
  SI.Length rs[nTheta,nZ] "Position in r-dimension";
  SI.Angle thetas[nTheta,nZ] "Position in theta-dimension";
  SI.Length zs[nTheta,nZ] "Position in z-dimension";
initial equation
  for i in 1:nZ loop
    if abs(sum(dthetas[:, i]) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
      closedDim_1[i] = true;
    else
      closedDim_1[i] = false;
    end if;
  end for;
  closedDim_2 = fill(false,nTheta);
algorithm
  for j in 1:nTheta loop
    for k in 1:nZ loop
      rs[j, k] := r_inner + 0.5*drs[j, k];
    end for;
  end for;
  for k in 1:nZ loop
    thetas[1, k] := 0.5*dthetas[1, k];
    for j in 2:nTheta loop
      thetas[j, k] := sum(dthetas[1:j - 1, k]) + 0.5*dthetas[j, k];
    end for;
  end for;
  for j in 1:nTheta loop
    zs[j, 1] := 0.5*dzs[j, 1];
    for k in 2:nZ loop
      zs[j, k] := sum(dzs[j, 1:k - 1]) + 0.5*dzs[j, k];
    end for;
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      Vs[j, k] := 0.5*((rs[j, k] + 0.5*drs[j, k])^2 - (rs[j, k] - 0.5*drs[j, k])
        ^2)*dthetas[j, k]*dzs[j, k];
    end for;
  end for;
  for k in 1:nZ loop
    for j in 1:nTheta loop
      crossAreas_1[j, k] := drs[j, k]*dzs[j, k];
    end for;
    crossAreas_1[nTheta + 1, k] := drs[nTheta, k]*dzs[nTheta, k];
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      crossAreas_2[j, k] := 0.5*((rs[j, k] + 0.5*drs[j, k])^2 - (rs[j, k] - 0.5
        *drs[j, k])^2)*dthetas[j, k];
    end for;
    crossAreas_2[j, nZ + 1] := 0.5*((rs[j, nZ] + 0.5*drs[j, nZ])^2 - (rs[j, nZ]
       - 0.5*drs[j, nZ])^2)*dthetas[j, nZ];
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      dlengths_1[j, k] := rs[j, k]*dthetas[j, k];
      dlengths_2[j, k] := dzs[j, k];
    end for;
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      cs_1[j, k] := rs[j, k]*Modelica.Math.sin(thetas[j, k]);
      cs_2[j, k] := zs[j, k];
    end for;
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      surfaceAreas_3a[j, k] := r_inner*dthetas[j, k]*dzs[j, k];
      surfaceAreas_3b[j, k] := (r_inner + drs[j, k])*dthetas[j, k]*dzs[j, k];
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_2D_theta_z;
