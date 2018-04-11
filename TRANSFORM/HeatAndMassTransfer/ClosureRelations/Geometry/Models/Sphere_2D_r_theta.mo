within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_2D_r_theta

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nR,nTheta}, final figure=3);

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
  input SI.Angle angle_phi(
    min=0,
    max=Modelica.Constants.pi) = Modelica.Constants.pi
    "Specify angle or dphis in phi-dimension"
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
  input SI.Angle dphis[nR,nTheta](min=0) = fill(
    angle_phi,
    nR,
    nTheta) "Unit volume lengths of phi-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nR,nTheta] "Position in r-dimension";
  SI.Angle thetas[nR,nTheta] "Position in theta-dimension";
  SI.Angle phis[nR,nTheta] "Position in phi-dimension";

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
      phis[i, j] := 0.5*dphis[i, j];
    end for;
  end for;

  for i in 1:nR loop
    for j in 1:nTheta loop
      Vs[i, j] := 1/3*((rs[i, j] + 0.5*drs[i, j])^3 - (rs[i, j] - 0.5*drs[i, j])
        ^3)*dthetas[i, j]*(-Modelica.Math.cos(phis[i, j] + 0.5*dphis[i, j]) +
        Modelica.Math.cos(phis[i, j] - 0.5*dphis[i, j]));
    end for;
  end for;

  for j in 1:nTheta loop
    for i in 1:nR loop
      crossAreas_1[i, j] := (rs[i, j] - 0.5*drs[i, j])^2*dthetas[i, j]*(-
        Modelica.Math.cos(phis[i, j] + 0.5*dphis[i, j]) + Modelica.Math.cos(
        phis[i, j] - 0.5*dphis[i, j]));
    end for;
    crossAreas_1[nR + 1, j] := (rs[nR, j] + 0.5*drs[nR, j])^2*dthetas[nR, j]*(-
      Modelica.Math.cos(phis[nR, j] + 0.5*dphis[nR, j]) + Modelica.Math.cos(
      phis[nR, j] - 0.5*dphis[nR, j]));
  end for;

  for i in 1:nR loop
    for j in 1:nTheta loop
      crossAreas_2[i, j] := 0.5*((rs[i, j] + 0.5*drs[i, j])^2 - (rs[i, j] - 0.5
        *drs[i, j])^2)*dthetas[i, j]*Modelica.Math.sin(phis[i, j]);
    end for;
    crossAreas_2[i, nTheta + 1] := 0.5*((rs[i, nTheta] + 0.5*drs[i, nTheta])^2
       - (rs[i, nTheta] - 0.5*drs[i, nTheta])^2)*dthetas[i, nTheta]*
      Modelica.Math.sin(phis[i, nTheta]);
  end for;

  for i in 1:nR loop
    for j in 1:nTheta loop
      dlengths_1[i, j] := drs[i, j];
      dlengths_2[i, j] := rs[i, j]*Modelica.Math.sin(phis[i, j])*dthetas[i, j];
    end for;
  end for;

  for i in 1:nR loop
    for j in 1:nTheta loop
      cs_1[i, j] := rs[i, j]*Modelica.Math.cos(thetas[i, j])*Modelica.Math.sin(
        phis[i, j]);
      cs_2[i, j] := rs[i, j]*Modelica.Math.sin(thetas[i, j])*Modelica.Math.sin(
        phis[i, j]);
    end for;
  end for;

  for i in 1:nR loop
    for k in 1:nTheta loop
      if dphis[i, k] < Modelica.Constants.pi then
        if i == 1 then
          surfaceAreas_3a[i, k] := ((r_inner + drs[i, k])^2 - r_inner^2)*dphis[
            i, k];
          surfaceAreas_3b[i, k] := ((r_inner + drs[i, k])^2 - r_inner^2)*dphis[
            i, k];
        else
          surfaceAreas_3a[i, k] := ((r_inner + sum(drs[1:i - 1, k]) + 0.5*drs[i,
            k])^2 - (r_inner + sum(drs[1:i - 1, k]) - 0.5*drs[i, k])^2)*dphis[i,
            k];
          surfaceAreas_3b[i, k] := ((r_inner + sum(drs[1:i - 1, k]) + 0.5*drs[i,
            k])^2 - (r_inner + sum(drs[1:i - 1, k]) - 0.5*drs[i, k])^2)*dphis[i,
            k];
        end if;
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
end Sphere_2D_r_theta;
