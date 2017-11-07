within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model ForwardDifference_1O
  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.PartialDistributedFlow;

equation

  for i in 1:nFM_1 loop
    Q_flows_1[i] = -0.5*(lambdas_1[i] + lambdas_1[i + 1])*crossAreas_1[i]*(Ts_1[i + 1]
       - Ts_1[i])/lengths_1[i];
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifference_1O;
