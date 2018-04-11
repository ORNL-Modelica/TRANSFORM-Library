within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
model AlphasM "Specify Mass Transfer Coefficient (alphaM)"

  import TRANSFORM.Math.fillArray_1D;

  extends PartialSinglePhase;

  input Units.CoefficientOfMassTransfer alphaM0[Medium.nC]=fill(0, Medium.nC)
    "Coefficient of mass transfer" annotation (Dialog(group="Inputs"));
  input Units.CoefficientOfMassTransfer alphasM0[nMT,Medium.nC]=fillArray_1D(
      alphaM0, nMT) "if non-uniform then set"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nMT loop
    alphasM[i, :] = alphasM0[i, :];
    Shs[i, :] =alphasM[i, :] .* dimensions[i] ./diffusionCoeff[i].D_abs;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AlphasM;
