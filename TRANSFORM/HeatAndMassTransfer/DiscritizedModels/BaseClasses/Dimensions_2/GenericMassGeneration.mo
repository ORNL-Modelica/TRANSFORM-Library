within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model GenericMassGeneration "Molar generation rate set for each volume"
  import TRANSFORM.Math.fillArray_2D;
  extends PartialInternalMassGeneration;
  input SI.MolarFlowRate n_gen[nC] = zeros(nC) "Molar generation rate in every volume" annotation(Dialog(group="Inputs"));
  input SI.MolarFlowRate n_gens[nVs[1],nVs[2],nC] = fillArray_2D(n_gen,nVs[1],nVs[2]) "Molar generation rate in each volume, if not uniform" annotation(Dialog(group="Inputs"));
equation
  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      n_flows[i, j,ic] = n_gens[i, j,ic];
    end for;
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassGeneration;
