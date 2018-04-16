within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_1D_theta

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nTheta}, final figure=3);

  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";

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

  input SI.Length drs[nTheta](min=0) = fill(r_outer - r_inner, nTheta)
    "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nTheta](min=0) = fill(angle_theta/nTheta, nTheta)
    "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dphis[nTheta](min=0) = fill(angle_phi, nTheta)
    "Unit volume lengths of phi-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nTheta] "Position in r-dimension";
  SI.Angle thetas[nTheta] "Position in theta-dimension";
  SI.Angle phis[nTheta] "Position in phi-dimension";

algorithm

  for j in 1:nTheta loop
    rs[j] := r_inner + 0.5*drs[j];
  end for;

  thetas[1] := 0.5*dthetas[1];
  for j in 2:nTheta loop
    thetas[j] := sum(dthetas[1:j - 1]) + 0.5*dthetas[j];
  end for;

  for j in 1:nTheta loop
    phis[j] := 0.5*dphis[j];
  end for;

  for j in 1:nTheta loop
    Vs[j] := 1/3*((rs[j] + 0.5*drs[j])^3 - (rs[j] - 0.5*drs[j])^3)*dthetas[j]*(
      -Modelica.Math.cos(phis[j] + 0.5*dphis[j]) + Modelica.Math.cos(phis[j] -
      0.5*dphis[j]));
  end for;

  for j in 1:nTheta loop
    crossAreas_1[j] := 0.5*((rs[j] + 0.5*drs[j])^2 - (rs[j] - 0.5*drs[j])^2)*
      dthetas[j]*Modelica.Math.sin(phis[j]);
  end for;
  crossAreas_1[nTheta + 1] := 0.5*((rs[nTheta] + 0.5*drs[nTheta])^2 - (rs[
    nTheta] - 0.5*drs[nTheta])^2)*dthetas[nTheta]*Modelica.Math.sin(phis[nTheta]);

  for j in 1:nTheta loop
    dlengths_1[j] := rs[j]*Modelica.Math.sin(phis[j])*dthetas[j];
  end for;

  for j in 1:nTheta loop
    cs_1[j] := rs[j]*Modelica.Math.sin(thetas[j])*Modelica.Math.sin(phis[j]);
  end for;

  for i in 1:nTheta loop
    surfaceAreas_2a[i] := r_inner^2*dthetas[i]*(1 - Modelica.Math.cos(dphis[i]));
    surfaceAreas_2b[i] := (r_inner + sum(drs))^2*dthetas[i]*(1 -
      Modelica.Math.cos(dphis[i]));

    if dphis[i] < Modelica.Constants.pi then
      if i == 1 then
        surfaceAreas_3a[i] := ((r_inner + drs[i])^2 - r_inner^2)*dphis[i];
        surfaceAreas_3b[i] := ((r_inner + drs[i])^2 - r_inner^2)*dphis[i];
      else
        surfaceAreas_3a[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
          r_inner + sum(drs[1:i - 1]) - 0.5*drs[i])^2)*dphis[i];
        surfaceAreas_3b[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
          r_inner + sum(drs[1:i - 1]) - 0.5*drs[i])^2)*dphis[i];
      end if;
    else
      surfaceAreas_3a[i] := 0;
      surfaceAreas_3b[i] := 0;
    end if;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sphere_1D_theta;
