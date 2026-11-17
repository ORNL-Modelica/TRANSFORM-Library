within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model VolumetricMassGeneration "Molar generation rate per unit volume"
  import TRANSFORM.Math.fillArray_1D;
  extends PartialInternalMassGeneration;
  input SI.Concentration n_ppp[nC] = zeros(nC) "Molar generation rate per unit volume in every volume" annotation(Dialog(group="Inputs"));
  input SI.Concentration n_ppps[nVs[1],nC] = fillArray_1D(n_ppp,nVs[1]) "Molar generation rate per unit volume, if not uniform" annotation(Dialog(group="Inputs"));
equation
  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    n_flows[i,ic] = n_ppps[i,ic]*Vs[i];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricMassGeneration;
