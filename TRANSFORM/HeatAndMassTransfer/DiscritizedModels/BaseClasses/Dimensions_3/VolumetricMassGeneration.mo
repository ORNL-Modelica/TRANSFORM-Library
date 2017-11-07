within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model VolumetricMassGeneration

  import TRANSFORM.Math.fillArray_3D;

  extends PartialInternalMassGeneration;

  input SI.Concentration n_ppp[nC] = zeros(nC) "Molar concentration generation" annotation(Dialog(group="Input Variables"));
  input SI.Concentration n_ppps[nVs[1],nVs[2],nVs[3],nC] = fillArray_3D(n_ppp,nVs[1],nVs[2],nVs[3]) "if non-uniform then set n_ppps" annotation(Dialog(group="Input Variables"));

equation

  for ic in 1:nC loop
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      for k in 1:nVs[3] loop
        n_flows[i, j, k, ic] = n_ppps[i, j, k, ic]*Vs[i, j, k];
      end for;
    end for;
  end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricMassGeneration;
