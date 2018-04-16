within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_1D_r

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nR}, final figure=3);

  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";

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

  input SI.Length drs[nR](min=0) = fill((r_outer - r_inner)/nR, nR)
    "Unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dthetas[nR](min=0) = fill(angle_theta, nR)
    "Unit volume lengths of theta-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Angle dphis[nR](min=0) = fill(angle_phi, nR)
    "Unit volume lengths of phi-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length rs[nR] "Position in r-dimension";
  SI.Angle thetas[nR] "Position in theta-dimension";
  SI.Angle phis[nR] "Position in phi-dimension";

algorithm

  rs[1] := r_inner + 0.5*drs[1];
  for i in 2:nR loop
    rs[i] := r_inner + sum(drs[1:i - 1]) + 0.5*drs[i];
  end for;

  for i in 1:nR loop
    thetas[i] := 0.5*dthetas[i];
  end for;

  for i in 1:nR loop
    phis[i] := 0.5*dphis[i];
  end for;

  for i in 1:nR loop
    Vs[i] := 1/3*((rs[i] + 0.5*drs[i])^3 - (rs[i] - 0.5*drs[i])^3)*dthetas[i]*(
      -Modelica.Math.cos(phis[i] + 0.5*dphis[i]) + Modelica.Math.cos(phis[i] -
      0.5*dphis[i]));
  end for;

  for i in 1:nR loop
    crossAreas_1[i] := (rs[i] - 0.5*drs[i])^2*dthetas[i]*(-Modelica.Math.cos(
      phis[i] + 0.5*dphis[i]) + Modelica.Math.cos(phis[i] - 0.5*dphis[i]));
  end for;
  crossAreas_1[nR + 1] := (rs[nR] + 0.5*drs[nR])^2*dthetas[nR]*(-
    Modelica.Math.cos(phis[nR] + 0.5*dphis[nR]) + Modelica.Math.cos(phis[nR] -
    0.5*dphis[nR]));

  for i in 1:nR loop
    dlengths_1[i] := drs[i];
  end for;

  for i in 1:nR loop
    cs_1[i] := rs[i]*Modelica.Math.cos(thetas[i])*Modelica.Math.sin(phis[i]);
  end for;

  for i in 1:nR loop
    if dthetas[i] < 2*Modelica.Constants.pi then
      if i == 1 then
        surfaceAreas_2a[i] := ((r_inner + drs[i])^2 - r_inner^2)*dthetas[i]*
          Modelica.Math.sin(phis[i]);
        surfaceAreas_2b[i] := ((r_inner + drs[i])^2 - r_inner^2)*dthetas[i]*
          Modelica.Math.sin(phis[i]);
      else
        surfaceAreas_2a[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
          r_inner + sum(drs[1:i - 1]) - 0.5*drs[i])^2)*dthetas[i]*
          Modelica.Math.sin(phis[i]);
        surfaceAreas_2b[i] := ((r_inner + sum(drs[1:i - 1]) + 0.5*drs[i])^2 - (
          r_inner + sum(drs[1:i - 1]) - 0.5*drs[i])^2)*dthetas[i]*
          Modelica.Math.sin(phis[i]);
      end if;
    else
      surfaceAreas_2a[i] := 0;
      surfaceAreas_2b[i] := 0;
    end if;

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
end Sphere_1D_r;
