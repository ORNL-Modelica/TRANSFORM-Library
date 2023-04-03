within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Cylinder_3D
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_3D(
      final ns={nR,nTheta,nZ}, final figure=2);
  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";
  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";
  input SI.Length r_inner = 0 "Specify inner radius or dthetas in r-dimension and r_outer" annotation(Dialog(group="Inputs"));
  input SI.Length r_outer = 1 "Specify outer radius or dthetas in r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle angle_theta(min=0,max=2*Modelica.Constants.pi) = 2*Modelica.Constants.pi "Specify overall angle or dthetas in theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length_z = 1 "Specify overall length or dzs in z-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length drs[nR,nTheta,nZ](min=0) = fill((r_outer-r_inner)/nR,nR,nTheta,nZ) "Unit volume lengths of r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle dthetas[nR,nTheta,nZ](min=0) = fill(angle_theta/nTheta,nR,nTheta,nZ)  "Unit volume lengths of theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length dzs[nR,nTheta,nZ](min=0) = fill((length_z)/nZ,nR,nTheta,nZ) "Unit volume lengths of z-dimension" annotation(Dialog(group="Inputs"));
  SI.Length rs[nR,nTheta,nZ] "Position in r-dimension";
  SI.Angle thetas[nR,nTheta,nZ] "Position in theta-dimension";
  SI.Length zs[nR,nTheta,nZ] "Position in z-dimension";
initial equation
  closedDim_1 = fill(false,nTheta,nZ);
  for i in 1:nR loop
    for j in 1:nZ loop
      if abs(sum(dthetas[i, :, j]) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
        closedDim_2[i,j] = true;
      else
        closedDim_2[i,j] = false;
      end if;
    end for;
  end for;
  closedDim_3 = fill(false,nR,nTheta);
algorithm
  for j in 1:nTheta loop
    for k in 1:nZ loop
      rs[1,j,k] :=r_inner + 0.5*drs[1, j, k];
      for i in 2:nR loop
        rs[i, j, k] :=r_inner + sum(drs[1:i - 1, j, k]) + 0.5*drs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      thetas[i, 1, k] := 0.5*dthetas[i, 1, k];
      for j in 2:nTheta loop
        thetas[i, j, k] :=sum(dthetas[i, 1:j - 1, k]) + 0.5*dthetas[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      zs[i, j, 1] :=0.5*dzs[i, j, 1];
      for k in 2:nZ loop
        zs[i, j, k] :=sum(dzs[i, j, 1:k - 1]) + 0.5*dzs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nZ loop
        Vs[i,j,k] :=
          0.5*((rs[i,j,k]+0.5*drs[i,j,k])^2-(rs[i,j,k]-0.5*drs[i,j,k])^2)
          *dthetas[i,j,k]
          *dzs[i,j,k];
      end for;
    end for;
  end for;
  for j in 1:nTheta loop
    for k in 1:nZ loop
      for i in 1:nR loop
        crossAreas_1[i,j,k] :=
          (rs[i,j,k]-0.5*drs[i,j,k])
          *dthetas[i, j, k]
          *dzs[i, j, k];
      end for;
      crossAreas_1[nR + 1,j,k] :=
          (rs[nR,j,k]+0.5*drs[nR,j,k])
          *dthetas[nR, j, k]
          *dzs[nR, j, k];
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nZ loop
      for j in 1:nTheta loop
        crossAreas_2[i,j,k] :=drs[i, j, k]*dzs[i, j, k];
      end for;
      crossAreas_2[i,nTheta+1,k] :=drs[i, nTheta, k]*dzs[i, nTheta, k];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nZ loop
        crossAreas_3[i,j,k] :=
          0.5*((rs[i,j,k]+0.5*drs[i,j,k])^2 - (rs[i,j,k]-0.5*drs[i,j,k])^2)
          *dthetas[i, j, k];
      end for;
      crossAreas_3[i,j,nZ+1] :=
        0.5*((rs[i,j,nZ]+0.5*drs[i,j,nZ])^2 - (rs[i,j,nZ]-0.5*drs[i,j,nZ])^2)
        *dthetas[i, j, nZ];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nZ loop
        dlengths_1[i,j,k] :=drs[i, j, k];
        dlengths_2[i,j,k] :=rs[i,j,k]*dthetas[i, j, k];
        dlengths_3[i,j,k] :=dzs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nZ loop
        cs_1[i,j,k] :=rs[i,j,k]*Modelica.Math.cos(thetas[i,j,k]);
        cs_2[i,j,k] :=rs[i,j,k]*Modelica.Math.sin(thetas[i,j,k]);
        cs_3[i,j,k] :=zs[i, j, k];
      end for;
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder_3D;
