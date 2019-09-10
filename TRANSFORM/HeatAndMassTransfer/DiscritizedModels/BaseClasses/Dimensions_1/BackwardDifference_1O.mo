within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model BackwardDifference_1O
  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.PartialDistributedFlow;
equation
  for i in 2:nFM_1 + 1 loop
    Q_flows_1[i - 1] = -0.5*(lambdas_1[i] + lambdas_1[i - 1])*crossAreas_1[i - 1]*(
      Ts_1[i] - Ts_1[i - 1])/lengths_1[i - 1];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BackwardDifference_1O;
