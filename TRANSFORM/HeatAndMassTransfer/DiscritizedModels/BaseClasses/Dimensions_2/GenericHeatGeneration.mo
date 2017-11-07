within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model GenericHeatGeneration

  extends PartialInternalHeatGeneration;

  input SI.HeatFlowRate Q_gen=0 "Per volume heat generation"
    annotation (Dialog(group="Input Variables"));
  input SI.HeatFlowRate Q_gens[nVs[1],nVs[2]]=fill(
      Q_gen,
      nVs[1],
      nVs[2]) "if non-uniform then set Q_gens"
    annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      Q_flows[i, j] = Q_gens[i, j];
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericHeatGeneration;
