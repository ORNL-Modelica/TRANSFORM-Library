within TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D;
model VolumetricHeatGeneration

  extends PartialInternalHeatGeneration;

  input Units.VolumetricHeatGenerationRate q_ppp = 0 "Volumetric heat generation" annotation(Dialog(group="Input Variables"));
  input Units.VolumetricHeatGenerationRate q_ppps[nV]=fill(q_ppp, nV)
    "if non-uniform then set q_ppps"
    annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nV loop
    Q_flows[i] = q_ppps[i]*Vs[i];
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricHeatGeneration;
