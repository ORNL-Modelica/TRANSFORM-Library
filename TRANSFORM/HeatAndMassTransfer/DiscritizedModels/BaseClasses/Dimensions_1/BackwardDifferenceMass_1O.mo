within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model BackwardDifferenceMass_1O
  extends PartialDistributedMassFlow;

equation
  for ic in 1:nC loop
  for i in 2:nFM_1 + 1 loop
    n_flows_1[i - 1,ic] = -0.5*(D_abs_1[i,ic] + D_abs_1[i - 1,ic])*crossAreas_1[i - 1]*(Cs_1
          [i,ic] -Cs_1 [i - 1,ic])/lengths_1[i - 1];
  end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BackwardDifferenceMass_1O;
