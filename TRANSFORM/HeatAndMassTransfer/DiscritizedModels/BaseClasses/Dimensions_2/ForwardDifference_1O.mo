within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model ForwardDifference_1O
  extends TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.PartialDistributedFlow;
equation
  if adiabaticDims[1] == false then
    for i in 1:nFM_1 loop
      for j in 1:nVs[2] loop
        Q_flows_1[i, j] = -0.5*(lambdas_1[i, j] + lambdas_1[i + 1, j])*
          crossAreas_1[i, j]*(Ts_1[i + 1, j] - Ts_1[i, j])/lengths_1[i, j];
      end for;
    end for;
  else
    for i in 1:nFM_1 loop
      for j in 1:nVs[2] loop
        Q_flows_1[i, j] = 0;
      end for;
    end for;
  end if;
  if adiabaticDims[2] == false then
    for i in 1:nVs[1] loop
      for j in 1:nFM_2 loop
        Q_flows_2[i, j] = -0.5*(lambdas_2[i, j] + lambdas_2[i, j + 1])*
          crossAreas_2[i, j]*(Ts_2[i, j + 1] - Ts_2[i, j])/lengths_2[i, j];
      end for;
    end for;
  else
    for i in 1:nVs[1] loop
      for j in 1:nFM_2 loop
        Q_flows_2[i, j] = 0;
      end for;
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifference_1O;
