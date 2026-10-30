within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model TotalHeatGeneration
  extends PartialInternalHeatGeneration;
  input SI.HeatFlowRate Q_gen = 0 "Total heat generation over entire volume" annotation(Dialog(group="Inputs"));
  input SI.HeatFlowRate Q_gens[nVs[1]] = fill(Q_gen/nVs[1],nVs[1]) "if non-uniform then set Q_gens" annotation(Dialog(group="Inputs"));
equation
  for i in 1:nVs[1] loop
    Q_flows[i] = Q_gens[i];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TotalHeatGeneration;
