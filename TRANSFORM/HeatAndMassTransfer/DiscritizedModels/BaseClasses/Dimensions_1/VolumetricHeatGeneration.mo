within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model VolumetricHeatGeneration

  extends PartialInternalHeatGeneration;

  input Units.VolumetricHeatGenerationRate q_ppp = 0 "Volumetric heat generation" annotation(Dialog(group="Input Variables"));
  input Units.VolumetricHeatGenerationRate q_ppps[nVs[1]] = fill(q_ppp,nVs[1]) "if non-uniform then set q_ppps" annotation(Dialog(group="Input Variables"));

equation

  for i in 1:nVs[1] loop
    Q_flows[i] = q_ppps[i]*Vs[i];
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricHeatGeneration;
