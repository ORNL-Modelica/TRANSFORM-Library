within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Plane_1D

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D(
      final ns={nX}, final figure=1);

  parameter Integer nX(min=1) = 1 "Number of nodes in x-direction";

  input SI.Length length_x=1 "Specify overall length or dxs in x-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length length_y=1 "Specify length or dys in y-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length length_z=1 "Specify length or dzs in z-dimension"
    annotation (Dialog(group="Inputs"));

  input SI.Length dxs[nX](min=0) = fill((length_x)/nX, nX)
    "Unit volume lengths of x-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dys[nX](min=0) = fill(length_y, nX)
    "Unit volume lengths of y-dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length dzs[nX](min=0) = fill(length_z, nX)
    "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs"));

  SI.Length xs[nX] "Position in x-dimension";
  SI.Length ys[nX] "Position in y-dimension";
  SI.Length zs[nX] "Position in z-dimension";

initial equation
  closedDim_1 = false;

algorithm
  xs[1] := 0.5*dxs[1];
  for i in 2:nX loop
    xs[i] := sum(dxs[1:i - 1]) + 0.5*dxs[i];
  end for;

  for i in 1:nX loop
    ys[i] := 0.5*dys[i];
  end for;

  for i in 1:nX loop
    zs[i] := 0.5*dzs[i];
  end for;

  for i in 1:nX loop
    Vs[i] := dxs[i]*dys[i]*dzs[i];
  end for;

  for i in 1:nX loop
    crossAreas_1[i] := dys[i]*dzs[i];
  end for;
  crossAreas_1[nX + 1] := dys[nX]*dzs[nX];

  for i in 1:nX loop
    dlengths_1[i] := dxs[i];
  end for;

  for i in 1:nX loop
    cs_1[i] := xs[i];
  end for;

  for i in 1:nX loop
    surfaceAreas_2a[i] := dxs[i]*dys[i];
    surfaceAreas_2b[i] := dxs[i]*dys[i];
    surfaceAreas_3a[i] := dxs[i]*dzs[i];
    surfaceAreas_3b[i] := dxs[i]*dzs[i];
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Plane_1D;
