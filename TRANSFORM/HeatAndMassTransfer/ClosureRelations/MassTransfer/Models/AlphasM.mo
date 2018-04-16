within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
model AlphasM "Specify Mass Transfer Coefficient"

  import TRANSFORM.Math.fillArray_1D;

  extends PartialSinglePhase;

  input Units.CoefficientOfMassTransfer alphaM0[nC]=fill(0, nC)
    "Coefficient of mass transfer" annotation (Dialog(group="Inputs"));
  input Units.CoefficientOfMassTransfer alphasM0[nMT,nC]=fillArray_1D(
      alphaM0, nMT) "if non-uniform then set"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nMT loop
    alphasM[i, :] = alphasM0[i, :];
    Shs[i, :] =alphasM[i, :] .* dimensions[i] ./ Ds_ab[i, :];
  end for;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end AlphasM;
