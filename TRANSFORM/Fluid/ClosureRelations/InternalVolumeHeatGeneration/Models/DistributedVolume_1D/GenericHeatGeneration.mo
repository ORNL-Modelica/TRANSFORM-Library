within TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D;
model GenericHeatGeneration
  extends PartialInternalHeatGeneration;
  input SI.HeatFlowRate Q_gen = 0 "Per volume heat generation" annotation(Dialog(group="Inputs"));
  input SI.HeatFlowRate Q_gens[nV]=fill(Q_gen, nV)
    "if non-uniform then set Q_gens"
    annotation (Dialog(group="Inputs"));
equation
  for i in 1:nV loop
    Q_flows[i] = Q_gens[i];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericHeatGeneration;
