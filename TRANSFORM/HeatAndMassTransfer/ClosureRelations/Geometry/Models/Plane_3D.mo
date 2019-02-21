within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Plane_3D
  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_3D(
      final ns={nX,nY,nZ}, final figure=1);
  parameter Integer nX(min=1) = 1 "Number of nodes in x-direction";
  parameter Integer nY(min=1) = 1 "Number of nodes in y-direction";
  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";
  input SI.Length length_x = 1 "Specify overall length or dxs in x-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length_y = 1 "Specify overall length or dys in y-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length_z = 1 "Specify overall length or dzs in z-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length dxs[nX,nY,nZ](min=0) = fill((length_x)/nX,nX,nY,nZ) "Unit volume lengths of x-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length dys[nX,nY,nZ](min=0) = fill((length_y)/nY,nX,nY,nZ)  "Unit volume lengths of y-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length dzs[nX,nY,nZ](min=0) = fill((length_z)/nZ,nX,nY,nZ) "Unit volume lengths of z-dimension" annotation(Dialog(group="Inputs"));
  SI.Length xs[nX,nY,nZ] "Position in x-dimension";
  SI.Length ys[nX,nY,nZ] "Position in y-dimension";
  SI.Length zs[nX,nY,nZ] "Position in z-dimension";
initial equation
  closedDim_1 = fill(false,nY,nZ);
  closedDim_2 = fill(false,nX,nZ);
  closedDim_3 = fill(false,nX,nY);
algorithm
  for j in 1:nY loop
    for k in 1:nZ loop
      xs[1,j,k] :=0.5*dxs[1, j, k];
      for i in 2:nX loop
        xs[i, j, k] :=sum(dxs[1:i - 1, j, k]) + 0.5*dxs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nX loop
    for k in 1:nZ loop
      ys[i, 1, k] :=0.5*dys[i, 1, k];
      for j in 2:nY loop
        ys[i, j, k] :=sum(dys[i, 1:j - 1, k]) + 0.5*dys[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nX loop
    for j in 1:nY loop
      zs[i, j, 1] :=0.5*dzs[i, j, 1];
      for k in 2:nZ loop
        zs[i, j, k] :=sum(dzs[i, j, 1:k - 1]) + 0.5*dzs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nX loop
    for j in 1:nY loop
      for k in 1:nZ loop
        Vs[i,j,k] :=dxs[i, j, k]*dys[i, j, k]*dzs[i, j, k];
      end for;
    end for;
  end for;
  for j in 1:nY loop
    for k in 1:nZ loop
      for i in 1:nX loop
        crossAreas_1[i,j,k] :=dys[i, j, k]*dzs[i, j, k];
      end for;
      crossAreas_1[nX + 1,j,k] :=dys[nX, j, k]*dzs[nX, j, k];
    end for;
  end for;
  for i in 1:nX loop
    for k in 1:nZ loop
      for j in 1:nY loop
        crossAreas_2[i,j,k] :=dxs[i, j, k]*dzs[i, j, k];
      end for;
      crossAreas_2[i,nY+1,k] :=dxs[i, nY, k]*dzs[i, nY, k];
    end for;
  end for;
  for i in 1:nX loop
    for j in 1:nY loop
      for k in 1:nZ loop
        crossAreas_3[i,j,k] :=dxs[i, j, k]*dys[i, j, k];
      end for;
      crossAreas_3[i,j,nZ+1] :=dxs[i, j, nZ]*dys[i, j, nZ];
    end for;
  end for;
  for i in 1:nX loop
    for j in 1:nY loop
      for k in 1:nZ loop
        dlengths_1[i,j,k] :=dxs[i, j, k];
        dlengths_2[i,j,k] :=dys[i, j, k];
        dlengths_3[i,j,k] :=dzs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nX loop
    for j in 1:nY loop
      for k in 1:nZ loop
        cs_1[i,j,k] :=xs[i, j, k];
        cs_2[i,j,k] :=ys[i, j, k];
        cs_3[i,j,k] :=zs[i, j, k];
      end for;
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Plane_3D;
