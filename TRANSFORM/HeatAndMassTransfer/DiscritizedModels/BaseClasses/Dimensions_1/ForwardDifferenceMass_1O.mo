within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model ForwardDifferenceMass_1O
  extends PartialDistributedMassFlow;
equation
  for ic in 1:nC loop
  for i in 1:nFM_1 loop
    n_flows_1[i,ic] = -0.5*(D_abs_1[i,ic] + D_abs_1[i + 1,ic])*crossAreas_1[i]*(Cs_1[i + 1,ic]
       -Cs_1 [i,ic])/lengths_1[i];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifferenceMass_1O;
