within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Plane_2D

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D(
      final ns={nX,nY}, final figure=1);

  parameter Integer nX(min=1) = 1 "Number of nodes in x-direction";
  parameter Integer nY(min=1) = 1 "Number of nodes in y-direction";

  input SI.Length length_x=1 "Specify overall length or dxs in x-dimension"
    annotation (Dialog(group="Input Variables"));
  input SI.Length length_y=1 "Specify overall length or dys in y-dimension"
    annotation (Dialog(group="Input Variables"));
  input SI.Length length_z=1 "Specify length or dzs in z-dimension"
    annotation (Dialog(group="Input Variables"));

  input SI.Length dxs[nX,nY](min=0) = fill(
    (length_x)/nX,
    nX,
    nY) "Unit volume lengths of x-dimension"
    annotation (Dialog(group="Input Variables"));
  input SI.Length dys[nX,nY](min=0) = fill(
    (length_y)/nY,
    nX,
    nY) "Unit volume lengths of y-dimension"
    annotation (Dialog(group="Input Variables"));
  input SI.Length dzs[nX,nY](min=0) = fill(
    length_z,
    nX,
    nY) "Unit volume lengths of z-dimension"
    annotation (Dialog(group="Input Variables"));

  SI.Length xs[nX,nY] "Position in x-dimension";
  SI.Length ys[nX,nY] "Position in y-dimension";
  SI.Length zs[nX,nY] "Position in z-dimension";

algorithm

  for j in 1:nY loop
    xs[1, j] := 0.5*dxs[1, j];
    for i in 2:nX loop
      xs[i, j] := sum(dxs[1:i - 1, j]) + 0.5*dxs[i, j];
    end for;
  end for;

  for i in 1:nX loop
    ys[i, 1] := 0.5*dys[i, 1];
    for j in 2:nY loop
      ys[i, j] := sum(dys[i, 1:j - 1]) + 0.5*dys[i, j];
    end for;
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      zs[i, j] := 0.5*dzs[i, j];
    end for;
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      Vs[i, j] := dxs[i, j]*dys[i, j]*dzs[i, j];
    end for;
  end for;

  for j in 1:nY loop
    for i in 1:nX loop
      crossAreas_1[i, j] := dys[i, j]*dzs[i, j];
    end for;
    crossAreas_1[nX + 1, j] := dys[nX, j]*dzs[nX, j];
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      crossAreas_2[i, j] := dxs[i, j]*dzs[i, j];
    end for;
    crossAreas_2[i, nY + 1] := dxs[i, nY]*dzs[i, nY];
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      dlengths_1[i, j] := dxs[i, j];
      dlengths_2[i, j] := dys[i, j];
    end for;
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      cs_1[i, j] := xs[i, j];
      cs_2[i, j] := ys[i, j];
    end for;
  end for;

  for i in 1:nX loop
    for j in 1:nY loop
      surfaceAreas_3a[i, j] := dxs[i, j]*dys[i, j];
      surfaceAreas_3b[i, j] := dxs[i, j]*dys[i, j];
    end for;
  end for;

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Plane_2D;
