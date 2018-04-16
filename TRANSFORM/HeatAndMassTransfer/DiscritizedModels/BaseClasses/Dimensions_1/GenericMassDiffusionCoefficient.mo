within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model GenericMassDiffusionCoefficient

  import TRANSFORM.Math.fillArray_1D;

  extends PartialMassDiffusionCoefficient;

  input SI.MolarFlowRate D_ab0[nC] = zeros(nC) "Diffusion coefficient" annotation(Dialog(group="Inputs"));
  input SI.MolarFlowRate D_abs0[nVs[1],nC] = fillArray_1D(D_ab0,nVs[1]) "if non-uniform then set D_abs0" annotation(Dialog(group="Inputs"));

equation

  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    D_abs[i,ic] = D_abs0[i,ic];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassDiffusionCoefficient;
