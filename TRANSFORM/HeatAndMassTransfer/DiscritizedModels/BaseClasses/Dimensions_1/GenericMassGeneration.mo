within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model GenericMassGeneration "Molar generation rate set for each volume"
  import TRANSFORM.Math.fillArray_1D;
  extends PartialInternalMassGeneration;
  input SI.MolarFlowRate n_gen[nC] = zeros(nC) "Molar generation rate in every volume" annotation(Dialog(group="Inputs"));
  input SI.MolarFlowRate n_gens[nVs[1],nC] = fillArray_1D(n_gen,nVs[1]) "Molar generation rate in each volume, if not uniform" annotation(Dialog(group="Inputs"));
equation
  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    n_flows[i,ic] = n_gens[i,ic];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassGeneration;
