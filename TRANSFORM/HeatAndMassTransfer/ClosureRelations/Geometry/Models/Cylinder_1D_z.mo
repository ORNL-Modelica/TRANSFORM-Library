within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_1D_z

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nZ}, final figure=2);

  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";

  input SI.Length r_inner = 0 "Specify inner radius or dthetas in r-dimension and r_outer" annotation(Dialog(group="Inputs"));
  input SI.Length r_outer = 1 "Specify outer radius or dthetas in r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle angle_theta(min=0,max=2*Modelica.Constants.pi) = 2*Modelica.Constants.pi "Specify angle or dthetas in theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length_z = 1 "Specify overall length or dzs in z-dimension" annotation(Dialog(group="Inputs"));

  input SI.Length drs[nZ](min=0) = fill(r_outer-r_inner,nZ) "Unit volume lengths of r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle dthetas[nZ](min=0) = fill(angle_theta,nZ)  "Unit volume lengths of theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length dzs[nZ](min=0) = fill(length_z/nZ,nZ) "Unit volume lengths of z-dimension" annotation(Dialog(group="Inputs"));

  SI.Length rs[nZ] "Position in r-dimension";
  SI.Angle thetas[nZ] "Position in theta-dimension";
  SI.Length zs[nZ] "Position in z-dimension";

initial equation
  closedDim_1 = false;

equation

algorithm
  for k in 1:nZ loop
    rs[k] := r_inner + 0.5*drs[k];
  end for;

  for k in 1:nZ loop
    thetas[k] := 0.5*dthetas[k];
  end for;

  zs[1] := 0.5*dzs[1];
  for k in 2:nZ loop
    zs[k] := sum(dzs[1:k - 1]) + 0.5*dzs[k];
  end for;

  for k in 1:nZ loop
    Vs[k] := 0.5*((rs[k] + 0.5*drs[k])^2 - (rs[k] - 0.5*drs[k])^2)*dthetas[k]*
      dzs[k];
  end for;

  for k in 1:nZ loop
    crossAreas_1[k] := 0.5*((rs[k] + 0.5*drs[k])^2 - (rs[k] - 0.5*drs[k])^2)*
      dthetas[k];
  end for;
  crossAreas_1[nZ + 1] := 0.5*((rs[nZ] + 0.5*drs[nZ])^2 - (rs[nZ] - 0.5*drs[nZ])
    ^2)*dthetas[nZ];

  for k in 1:nZ loop
    dlengths_1[k] := dzs[k];
  end for;

  for k in 1:nZ loop
    cs_1[k] := zs[k];
  end for;

  for i in 1:nZ loop
    surfaceAreas_2a[i] := r_inner*dthetas[i]*dzs[i];
    surfaceAreas_2b[i] := (r_inner + drs[i])*dthetas[i]*dzs[i];

    if dthetas[i] < 2*Modelica.Constants.pi then
      surfaceAreas_3a[i] := drs[i]*dzs[i];
      surfaceAreas_3b[i] := drs[i]*dzs[i];
    else
      surfaceAreas_3a[i] := 0;
      surfaceAreas_3b[i] := 0;
    end if;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_1D_z;
