within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model VolumetricHeatGeneration
  extends PartialInternalHeatGeneration;
  input Units.VolumetricHeatGenerationRate q_ppp=0 "Volumetric heat generation"
    annotation (Dialog(group="Inputs"));
  input Units.VolumetricHeatGenerationRate q_ppps[nVs[1],nVs[2]]=fill(
      q_ppp,
      nVs[1],
      nVs[2]) "if non-uniform then set q_ppps"
    annotation (Dialog(group="Inputs"));
equation
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      Q_flows[i, j] = q_ppps[i, j]*Vs[i, j];
    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricHeatGeneration;
