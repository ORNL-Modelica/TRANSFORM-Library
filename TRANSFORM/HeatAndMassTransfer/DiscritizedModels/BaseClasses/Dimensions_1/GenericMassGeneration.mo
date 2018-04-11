within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model GenericMassGeneration

  import TRANSFORM.Math.fillArray_1D;

  extends PartialInternalMassGeneration;

  input SI.MolarFlowRate n_gen[nC] = zeros(nC) "Per volume mole generation" annotation(Dialog(group="Inputs"));
  input SI.MolarFlowRate n_gens[nVs[1],nC] = fillArray_1D(n_gen,nVs[1]) "if non-uniform then set n_gens" annotation(Dialog(group="Inputs"));

equation

  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    n_flows[i,ic] = n_gens[i,ic];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassGeneration;
