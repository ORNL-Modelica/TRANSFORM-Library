within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model VolumetricHeatGeneration
  extends PartialInternalHeatGeneration;
  input SItf.VolumetricHeatGenerationRate q_ppp = 0 "Volumetric heat generation" annotation(Dialog(group="Inputs"));
  input SItf.VolumetricHeatGenerationRate q_ppps[nVs[1]] = fill(q_ppp,nVs[1]) "if non-uniform then set q_ppps" annotation(Dialog(group="Inputs"));
equation
  for i in 1:nVs[1] loop
    Q_flows[i] = q_ppps[i]*Vs[i];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricHeatGeneration;
