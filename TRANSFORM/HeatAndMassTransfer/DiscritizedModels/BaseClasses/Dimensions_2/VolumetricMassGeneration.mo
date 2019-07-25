within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model VolumetricMassGeneration
  import TRANSFORM.Math.fillArray_2D;
  extends PartialInternalMassGeneration;
  input SI.Concentration n_ppp[nC] = fill(0,nC) "Molar concentration generation" annotation(Dialog(group="Inputs"));
  input SI.Concentration n_ppps[nVs[1],nVs[2],nC] = fillArray_2D(n_ppp,nVs[1],nVs[2]) "if non-uniform then set n_ppps" annotation(Dialog(group="Inputs"));
equation
  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      n_flows[i, j,ic] = n_ppps[i, j,ic]*Vs[i, j];
    end for;
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricMassGeneration;
