within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Alphas "Specify Heat Transfer Coefficient (alpha)"

  extends PartialSinglePhase;

  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Input Variables"));
  input SI.CoefficientOfHeatTransfer alphas0[nHT,nSurfaces]=fill(alpha0, nHT, nSurfaces)
    "if non-uniform then set" annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      alphas[i,j] = alphas0[i,j];
      Nus[i,j] =alphas[i, j]*dimensions[i]/mediaProps[i].lambda;
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas;
