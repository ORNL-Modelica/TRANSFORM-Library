within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model VolumetricHeatGeneration

  extends PartialInternalHeatGeneration;

  input Units.VolumetricHeatGenerationRate q_ppp=0 "Volumetric heat generation"
    annotation (Dialog(group="Inputs"));
  input Units.VolumetricHeatGenerationRate q_ppps[nVs[1],nVs[2],nVs[3]]=fill(
      q_ppp,
      nVs[1],
      nVs[2],
      nVs[3]) "if non-uniform then set q_ppps"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      for k in 1:nVs[3] loop
        Q_flows[i, j, k] = q_ppps[i, j, k]*Vs[i, j, k];
      end for;
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricHeatGeneration;
