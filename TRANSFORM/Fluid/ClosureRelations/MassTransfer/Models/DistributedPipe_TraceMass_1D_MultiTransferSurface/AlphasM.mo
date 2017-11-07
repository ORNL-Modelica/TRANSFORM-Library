within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface;
model AlphasM "Specify Mass Transfer Coefficient (alphaM)"

  import TRANSFORM.Math.fillArray_1D_2ns;

  extends PartialSinglePhase;

  input Units.CoefficientOfMassTransfer alphaM0[Medium.nC]=fill(0, Medium.nC)
    "Coefficient of mass transfer" annotation (Dialog(group="Input Variables"));
  input Units.CoefficientOfMassTransfer alphasM0[nMT,nSurfaces,Medium.nC]=fillArray_1D_2ns(
      alphaM0, nMT,nSurfaces) "if non-uniform then set"
    annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nMT loop
    for j in 1:nSurfaces loop
      alphasM[i, j, :] = alphasM0[i, j, :];
      Shs[i, j, :] = alphasM[i, j, :] .* dimensions[i] ./ diffusionCoeff[i].D_abs;
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AlphasM;
