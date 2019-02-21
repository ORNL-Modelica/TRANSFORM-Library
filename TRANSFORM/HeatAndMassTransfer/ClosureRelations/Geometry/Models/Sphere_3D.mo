within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
model Sphere_3D
  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_3D(
      final ns={nR,nTheta,nPhi}, final figure=3);
  parameter Integer nR(min=1) = 1 "Number of nodes in r-direction";
  parameter Integer nTheta(min=1) = 1 "Number of nodes in theta-direction";
  parameter Integer nPhi(min=1) = 1 "Number of nodes in phi-direction";
  input SI.Length r_inner = 0 "Specify inner radius or dthetas in r-dimension and r_outer" annotation(Dialog(group="Inputs"));
  input SI.Length r_outer = 1 "Specify outer radius or dthetas in r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle angle_theta(min=0,max=2*Modelica.Constants.pi) = 2*Modelica.Constants.pi "Specify overall angle or dthetas in theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle angle_phi(min=0,max=Modelica.Constants.pi) = Modelica.Constants.pi "Specify overall angle or dphis in phi-dimension" annotation(Dialog(group="Inputs"));
  input SI.Length drs[nR,nTheta,nPhi](min=0) = fill((r_outer-r_inner)/nR,nR,nTheta,nPhi) "Unit volume lengths of r-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle dthetas[nR,nTheta,nPhi](min=0) = fill(angle_theta/nTheta,nR,nTheta,nPhi)  "Unit volume lengths of theta-dimension" annotation(Dialog(group="Inputs"));
  input SI.Angle dphis[nR,nTheta,nPhi](min=0) = fill(angle_phi/nPhi,nR,nTheta,nPhi) "Unit volume lengths of phi-dimension" annotation(Dialog(group="Inputs"));
  SI.Length rs[nR,nTheta,nPhi] "Position in r-dimension";
  SI.Angle thetas[nR,nTheta,nPhi] "Position in theta-dimension";
  SI.Angle phis[nR,nTheta,nPhi] "Position in phi-dimension";
initial equation
  closedDim_1 = fill(false,nTheta,nPhi);
  for i in 1:nR loop
    for j in 1:nPhi loop
      if abs(sum(dthetas[i, :, j]) - 2*Modelica.Constants.pi) < Modelica.Constants.eps then
        closedDim_2[i,j] = true;
      else
        closedDim_2[i,j] = false;
      end if;
    end for;
  end for;
  for i in 1:nTheta loop
    for j in 1:nPhi loop
      if abs(sum(dphis[i, :, j]) - Modelica.Constants.pi) < Modelica.Constants.eps then
        closedDim_3[i,j] = true;
      else
        closedDim_3[i,j] = false;
      end if;
    end for;
  end for;
algorithm
  for j in 1:nTheta loop
    for k in 1:nPhi loop
      rs[1,j,k] :=r_inner + 0.5*drs[1, j, k];
      for i in 2:nR loop
        rs[i, j, k] :=r_inner + sum(drs[1:i - 1, j, k]) + 0.5*drs[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nPhi loop
      thetas[i, 1, k] := 0.5*dthetas[i, 1, k];
      for j in 2:nTheta loop
        thetas[i, j, k] :=sum(dthetas[i, 1:j - 1, k]) + 0.5*dthetas[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      phis[i, j, 1] :=0.5*dphis[i, j, 1];
      for k in 2:nPhi loop
        phis[i, j, k] :=sum(dphis[i, j, 1:k - 1]) + 0.5*dphis[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nPhi loop
        Vs[i,j,k] :=1/3*((rs[i,j,k]+0.5*drs[i,j,k])^3-(rs[i,j,k]-0.5*drs[i,j,k])^3)
          *dthetas[i,j,k]
          *(-Modelica.Math.cos(phis[i,j,k]+0.5*dphis[i, j, k])+Modelica.Math.cos(phis[i,j,k]-0.5*dphis[i, j, k]));
      end for;
    end for;
  end for;
  for j in 1:nTheta loop
    for k in 1:nPhi loop
      for i in 1:nR loop
        crossAreas_1[i,j,k] :=
          (rs[i,j,k]-0.5*drs[i,j,k])^2
          *dthetas[i, j, k]
          *(-Modelica.Math.cos(phis[i,j,k]+0.5*dphis[i,j,k])+
            Modelica.Math.cos(phis[i,j,k]-0.5*dphis[i,j,k]));
      end for;
      crossAreas_1[nR + 1,j,k] :=
          (rs[nR,j,k]+0.5*drs[nR,j,k])^2
          *dthetas[nR, j, k]
          *(-Modelica.Math.cos(phis[nR,j,k]+0.5*dphis[nR,j,k])+
            Modelica.Math.cos(phis[nR,j,k]-0.5*dphis[nR,j,k]));
    end for;
  end for;
  for i in 1:nR loop
    for k in 1:nPhi loop
      for j in 1:nTheta loop
        crossAreas_2[i,j,k] :=
          0.5*((rs[i,j,k]+0.5*drs[i,j,k])^2-(rs[i,j,k]-0.5*drs[i,j,k])^2)
          *dthetas[i,j,k]
          *Modelica.Math.sin(phis[i,j,k]);
      end for;
      crossAreas_2[i,nTheta+1,k] :=
          0.5*((rs[i,nTheta,k]+0.5*drs[i,nTheta,k])^2-(rs[i,nTheta,k]-0.5*drs[i,nTheta,k])^2)
          *dthetas[i,nTheta,k]
          *Modelica.Math.sin(phis[i,nTheta,k]);
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nPhi loop
        crossAreas_3[i,j,k] :=
          0.5*((rs[i,j,k]+0.5*drs[i,j,k])^2-(rs[i,j,k]-0.5*drs[i,j,k])^2)
          *dphis[i,j,k];
      end for;
      crossAreas_3[i,j,nPhi+1] :=
          0.5*((rs[i,j,nPhi]+0.5*drs[i,j,nPhi])^2-(rs[i,j,nPhi]-0.5*drs[i,j,nPhi])^2)
          *dphis[i,j,nPhi];
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nPhi loop
        dlengths_1[i,j,k] :=drs[i, j, k];
        dlengths_2[i,j,k] :=rs[i,j,k]*Modelica.Math.sin(phis[i,j,k])*dthetas[i, j, k];
        dlengths_3[i,j,k] :=rs[i,j,k]*dphis[i, j, k];
      end for;
    end for;
  end for;
  for i in 1:nR loop
    for j in 1:nTheta loop
      for k in 1:nPhi loop
        cs_1[i,j,k] :=rs[i,j,k]*Modelica.Math.cos(thetas[i,j,k])*Modelica.Math.sin(phis[i,j,k]);
        cs_2[i,j,k] :=rs[i,j,k]*Modelica.Math.sin(thetas[i,j,k])*Modelica.Math.sin(phis[i,j,k]);
        cs_3[i,j,k] :=rs[i,j,k]*Modelica.Math.cos(phis[i,j,k]);
      end for;
    end for;
  end for;
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sphere_3D;
