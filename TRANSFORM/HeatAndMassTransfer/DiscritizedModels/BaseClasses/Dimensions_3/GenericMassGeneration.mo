within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model GenericMassGeneration

  import TRANSFORM.Math.fillArray_3D;

  extends PartialInternalMassGeneration;

  input SI.MolarFlowRate n_gen[nC] = zeros(nC) "Per volume mole generation" annotation(Dialog(group="Input Variables"));
  input SI.MolarFlowRate n_gens[nVs[1],nVs[2],nVs[3],nC] = fillArray_3D(n_gen,nVs[1],nVs[2],nVs[3]) "if non-uniform then set n_gens" annotation(Dialog(group="Input Variables"));

equation

  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      for k in 1:nVs[3] loop
        n_flows[i, j, k, ic] = n_gens[i, j, k, ic];
      end for;
    end for;
  end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassGeneration;
