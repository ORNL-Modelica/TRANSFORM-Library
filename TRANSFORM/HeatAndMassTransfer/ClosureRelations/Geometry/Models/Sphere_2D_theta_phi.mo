within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_2D_theta_phi

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nTheta,nPhi}, final figure=3);

  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";
  parameter Integer nPhi(min=1) = 1 "Number of nodes in z-direction";

  input SI.Length r_inner=0
    "Specify inner radius and dthetas in r-dimension or r_outer"
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
    "Specify overall angle or dphis in phi-dimension"
    annotation (Dialog(group="Inputs"));

  input SI.Length drs[nTheta,nPhi](min=0) = fill(
    r_outer - r_inner,
    nTheta,
    nPhi) "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nTheta,nPhi](min=0) = fill(
    angle_theta/nTheta,
    nTheta,
    nPhi) "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dphis[nTheta,nPhi](min=0) = fill(
    angle_phi/nPhi,
    nTheta,
    nPhi) "Unit volume lengths of phi-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nTheta,nPhi] "Position in r-dimension";
  SI.Angle thetas[nTheta,nPhi] "Position in theta-dimension";
  SI.Angle phis[nTheta,nPhi] "Position in phi-dimension";

initial equation
  for i in 1:nPhi loop
    if abs(sum(dthetas[:, i]) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
      closedDim_1[i] = true;
    else
      closedDim_1[i] = false;
    end if;
  end for;

  for i in 1:nTheta loop
    if abs(sum(dphis[i, :]) - Modelica.Constants.pi) < Modelica.Constants.eps then
      closedDim_2[i] = true;
    else
      closedDim_2[i] = false;
    end if;
  end for;

equation

algorithm
  for j in 1:nTheta loop
    for k in 1:nPhi loop
      rs[j, k] := r_inner + 0.5*drs[j, k];
    end for;
  end for;

  for k in 1:nPhi loop
    thetas[1, k] := 0.5*dthetas[1, k];
    for j in 2:nTheta loop
      thetas[j, k] := sum(dthetas[1:j - 1, k]) + 0.5*dthetas[j, k];
    end for;
  end for;

  for j in 1:nTheta loop
    phis[j, 1] := 0.5*dphis[j, 1];
    for k in 2:nPhi loop
      phis[j, k] := sum(dphis[j, 1:k - 1]) + 0.5*dphis[j, k];
    end for;
  end for;

  for j in 1:nTheta loop
    for k in 1:nPhi loop
      Vs[j, k] := 1/3*((rs[j, k] + 0.5*drs[j, k])^3 - (rs[j, k] - 0.5*drs[j, k])
        ^3)*dthetas[j, k]*(-Modelica.Math.cos(phis[j, k] + 0.5*dphis[j, k]) +
        Modelica.Math.cos(phis[j, k] - 0.5*dphis[j, k]));
    end for;
  end for;

  for k in 1:nPhi loop
    for j in 1:nTheta loop
      crossAreas_1[j, k] := 0.5*((rs[j, k] + 0.5*drs[j, k])^2 - (rs[j, k] - 0.5
        *drs[j, k])^2)*dthetas[j, k]*Modelica.Math.sin(phis[j, k]);
    end for;
    crossAreas_1[nTheta + 1, k] := 0.5*((rs[nTheta, k] + 0.5*drs[nTheta, k])^2
       - (rs[nTheta, k] - 0.5*drs[nTheta, k])^2)*dthetas[nTheta, k]*
      Modelica.Math.sin(phis[nTheta, k]);
  end for;

  for j in 1:nTheta loop
    for k in 1:nPhi loop
      crossAreas_2[j, k] := 0.5*((rs[j, k] + 0.5*drs[j, k])^2 - (rs[j, k] - 0.5
        *drs[j, k])^2)*dphis[j, k];
    end for;
    crossAreas_2[j, nPhi + 1] := 0.5*((rs[j, nPhi] + 0.5*drs[j, nPhi])^2 - (rs[
      j, nPhi] - 0.5*drs[j, nPhi])^2)*dphis[j, nPhi];
  end for;

  for j in 1:nTheta loop
    for k in 1:nPhi loop
      dlengths_1[j, k] := rs[j, k]*Modelica.Math.sin(phis[j, k])*dthetas[j, k];
      dlengths_2[j, k] := rs[j, k]*dphis[j, k];
    end for;
  end for;

  for j in 1:nTheta loop
    for k in 1:nPhi loop
      cs_1[j, k] := rs[j, k]*Modelica.Math.sin(thetas[j, k])*Modelica.Math.sin(
        phis[j, k]);
      cs_2[j, k] := rs[j, k]*Modelica.Math.cos(phis[j, k]);
    end for;
  end for;

  for j in 1:nTheta loop
    for k in 1:nPhi loop
      surfaceAreas_3a[j, k] := r_inner^2*dthetas[j, k]*(1 - Modelica.Math.cos(
        dphis[j, k]));
      surfaceAreas_3b[j, k] := (r_inner + drs[j, k])^2*dthetas[j, k]*(1 -
        Modelica.Math.cos(dphis[j, k]));
    end for;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sphere_2D_theta_phi;
