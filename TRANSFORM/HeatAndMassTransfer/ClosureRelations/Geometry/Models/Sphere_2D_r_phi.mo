within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_2D_r_phi

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nR,nPhi}, final figure=3);

  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
  parameter Integer nPhi(min=1) = 1 "Number of nodes in z-direction";

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
  input SI.Angle angle_phi(
    min=0,
    max=Modelica.Constants.pi) = Modelica.Constants.pi
    "Specify overall angle or dphis in phi-dimension"
    annotation (Dialog(group="Inputs"));

  input SI.Length drs[nR,nPhi](min=0) = fill(
    (r_outer - r_inner)/nR,
    nR,
    nPhi) "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nR,nPhi](min=0) = fill(
    angle_theta,
    nR,
    nPhi) "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dphis[nR,nPhi](min=0) = fill(
    angle_phi/nPhi,
    nR,
    nPhi) "Unit volume lengths of phi-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nR,nPhi] "Position in r-dimension";
  SI.Angle thetas[nR,nPhi] "Position in theta-dimension";
  SI.Angle phis[nR,nPhi] "Position in phi-dimension";

algorithm

  for k in 1:nPhi loop
    rs[1, k] := r_inner + 0.5*drs[1, k];
    for i in 2:nR loop
      rs[i, k] := r_inner + sum(drs[1:i - 1, k]) + 0.5*drs[i, k];
    end for;
  end for;

  for i in 1:nR loop
    for k in 1:nPhi loop
      thetas[i, k] := 0.5*dthetas[i, k];
    end for;
  end for;

  for i in 1:nR loop
    phis[i, 1] := 0.5*dphis[i, 1];
    for k in 2:nPhi loop
      phis[i, k] := sum(dphis[i, 1:k - 1]) + 0.5*dphis[i, k];
    end for;
  end for;

  for i in 1:nR loop
    for k in 1:nPhi loop
      Vs[i, k] := 1/3*((rs[i, k] + 0.5*drs[i, k])^3 - (rs[i, k] - 0.5*drs[i, k])
        ^3)*dthetas[i, k]*(-Modelica.Math.cos(phis[i, k] + 0.5*dphis[i, k]) +
        Modelica.Math.cos(phis[i, k] - 0.5*dphis[i, k]));
    end for;
  end for;

  for k in 1:nPhi loop
    for i in 1:nR loop
      crossAreas_1[i, k] := (rs[i, k] - 0.5*drs[i, k])^2*dthetas[i, k]*(-
        Modelica.Math.cos(phis[i, k] + 0.5*dphis[i, k]) + Modelica.Math.cos(
        phis[i, k] - 0.5*dphis[i, k]));
    end for;
    crossAreas_1[nR + 1, k] := (rs[nR, k] + 0.5*drs[nR, k])^2*dthetas[nR, k]*(-
      Modelica.Math.cos(phis[nR, k] + 0.5*dphis[nR, k]) + Modelica.Math.cos(
      phis[nR, k] - 0.5*dphis[nR, k]));
  end for;

  for i in 1:nR loop
    for k in 1:nPhi loop
      crossAreas_2[i, k] := 0.5*((rs[i, k] + 0.5*drs[i, k])^2 - (rs[i, k] - 0.5
        *drs[i, k])^2)*dphis[i, k];
    end for;
    crossAreas_2[i, nPhi + 1] := 0.5*((rs[i, nPhi] + 0.5*drs[i, nPhi])^2 - (rs[
      i, nPhi] - 0.5*drs[i, nPhi])^2)*dphis[i, nPhi];
  end for;

  for i in 1:nR loop
    for k in 1:nPhi loop
      dlengths_1[i, k] := drs[i, k];
      dlengths_2[i, k] := rs[i, k]*dphis[i, k];
    end for;
  end for;

  for i in 1:nR loop
    for k in 1:nPhi loop
      cs_1[i, k] := rs[i, k]*Modelica.Math.cos(thetas[i, k])*Modelica.Math.sin(
        phis[i, k]);
      cs_2[i, k] := rs[i, k]*Modelica.Math.cos(phis[i, k]);
    end for;
  end for;

  for i in 1:nR loop
    for j in 1:nPhi loop
      if dthetas[i, j] < 2*Modelica.Constants.pi then
        if i == 1 then
          surfaceAreas_3a[i, j] := ((r_inner + drs[i, j])^2 - r_inner^2)*
            dthetas[i, j]*Modelica.Math.sin(phis[i, j]);
          surfaceAreas_3b[i, j] := ((r_inner + drs[i, j])^2 - r_inner^2)*
            dthetas[i, j]*Modelica.Math.sin(phis[i, j]);
        else
          surfaceAreas_3a[i, j] := ((r_inner + sum(drs[1:i - 1, j]) + 0.5*drs[i,
            j])^2 - (r_inner + sum(drs[1:i - 1, j]) - 0.5*drs[i, j])^2)*dthetas[
            i, j]*Modelica.Math.sin(phis[i, j]);
          surfaceAreas_3b[i, j] := ((r_inner + sum(drs[1:i - 1, j]) + 0.5*drs[i,
            j])^2 - (r_inner + sum(drs[1:i - 1, j]) - 0.5*drs[i, j])^2)*dthetas[
            i, j]*Modelica.Math.sin(phis[i, j]);
        end if;
      else
        surfaceAreas_3a[i, j] := 0;
        surfaceAreas_3b[i, j] := 0;
      end if;
    end for;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sphere_2D_r_phi;
