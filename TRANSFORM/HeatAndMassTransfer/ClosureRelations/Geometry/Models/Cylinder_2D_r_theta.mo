within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_2D_r_theta
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nR,nTheta}, final figure=2);
  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
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
  input SI.Length drs[nR,nTheta](min=0) = fill(
    (r_outer - r_inner)/nR,
    nR,
    nTheta) "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nR,nTheta](min=0) = fill(
    angle_theta/nTheta,
    nR,
    nTheta) "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nR,nTheta](min=0) = fill(
    length_z,
    nR,
    nTheta) "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));
  SI.Length rs[nR,nTheta] "Position in r-dimension";
  SI.Angle thetas[nR,nTheta] "Position in theta-dimension";
  SI.Length zs[nR,nTheta] "Position in z-dimension";
initial equation
  closedDim_1 = fill(false,nTheta);
  for i in 1:nR loop
    if abs(sum(dthetas[i, :]) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
      closedDim_2[i] = true;
    else
      closedDim_2[i] = false;
    end if;
  end for;
algorithm
  for j in 1:nTheta loop
    rs[1, j] := r_inner + 0.5*drs[1, j];
    for i in 2:nR loop
      rs[i, j] := r_inner + sum(drs[1:i - 1, j]) + 0.5*drs[i, j];
    end for;
  end for;
  for i in 1:nR loop
    thetas[i, 1] := 0.5*dthetas[i, 1];
    for j in 2:nTheta loop
      thetas[i, j] := sum(dthetas[i, 1:j - 1]) + 0.5*dthetas[i, j];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      zs[i, j] := 0.5*dzs[i, j];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      Vs[i, j] := 0.5*((rs[i, j] + 0.5*drs[i, j])^2 - (rs[i, j] - 0.5*drs[i, j])
        ^2)*dthetas[i, j]*dzs[i, j];
    end for;
  end for;
  for j in 1:nTheta loop
    for i in 1:nR loop
      crossAreas_1[i, j] := (rs[i, j] - 0.5*drs[i, j])*dthetas[i, j]*dzs[i, j];
    end for;
    crossAreas_1[nR + 1, j] := (rs[nR, j] + 0.5*drs[nR, j])*dthetas[nR, j]*dzs[
      nR, j];
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      crossAreas_2[i, j] := drs[i, j]*dzs[i, j];
    end for;
    crossAreas_2[i, nTheta + 1] := drs[i, nTheta]*dzs[i, nTheta];
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      dlengths_1[i, j] := drs[i, j];
      dlengths_2[i, j] := rs[i, j]*dthetas[i, j];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      cs_1[i, j] := rs[i, j]*Modelica.Math.cos(thetas[i, j]);
      cs_2[i, j] := rs[i, j]*Modelica.Math.sin(thetas[i, j]);
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      if i == 1 then
        surfaceAreas_3a[i, j] := ((r_inner + 0.5*drs[i, j])^2 - r_inner^2)*
          dthetas[i, j];
        surfaceAreas_3b[i, j] := ((r_inner + 0.5*drs[i, j])^2 - r_inner^2)*
          dthetas[i, j];
      else
        surfaceAreas_3a[i, j] := ((r_inner + sum(drs[1:i - 1, j]) + 0.5*drs[i,
          j])^2 - (r_inner + sum(drs[1:i - 1, j]) - 0.5*drs[i - 1, j])^2)*
          dthetas[i, j];
        surfaceAreas_3b[i, j] := ((r_inner + sum(drs[1:i - 1, j]) + 0.5*drs[i,
          j])^2 - (r_inner + sum(drs[1:i - 1, j]) - 0.5*drs[i - 1, j])^2)*
          dthetas[i, j];
      end if;
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_2D_r_theta;
