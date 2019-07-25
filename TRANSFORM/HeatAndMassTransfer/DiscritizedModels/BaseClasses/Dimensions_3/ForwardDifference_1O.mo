within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model ForwardDifference_1O
  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3.PartialDistributedFlow;
equation
  if adiabaticDims[1] == false then
    for i in 1:nFM_1 loop
      for j in 1:nVs[2] loop
        for k in 1:nVs[3] loop
          Q_flows_1[i, j, k] = -0.5*(lambdas_1[i, j, k] + lambdas_1[i + 1, j, k])
            *crossAreas_1[i, j, k]*(Ts_1[i + 1, j, k] - Ts_1[i, j, k])/
            lengths_1[i, j, k];
        end for;
      end for;
    end for;
  else
    for i in 1:nFM_1 loop
      for j in 1:nVs[2] loop
        for k in 1:nVs[3] loop
          Q_flows_1[i, j, k] = 0;
        end for;
      end for;
    end for;
  end if;
  if adiabaticDims[2] == false then
    for i in 1:nVs[1] loop
      for j in 1:nFM_2 loop
        for k in 1:nVs[3] loop
          Q_flows_2[i, j, k] = -0.5*(lambdas_2[i, j, k] + lambdas_2[i, j + 1, k])
            *crossAreas_2[i, j, k]*(Ts_2[i, j + 1, k] - Ts_2[i, j, k])/
            lengths_2[i, j, k];
        end for;
      end for;
    end for;
  else
    for i in 1:nVs[1] loop
      for j in 1:nFM_2 loop
        for k in 1:nVs[3] loop
          Q_flows_2[i, j, k] = 0;
        end for;
      end for;
    end for;
  end if;
  if adiabaticDims[3] == false then
    for i in 1:nVs[1] loop
      for j in 1:nVs[2] loop
        for k in 1:nFM_3 loop
          Q_flows_3[i, j, k] = -0.5*(lambdas_3[i, j, k] + lambdas_3[i, j, k + 1])
            *crossAreas_3[i, j, k]*(Ts_3[i, j, k + 1] - Ts_3[i, j, k])/
            lengths_3[i, j, k];
        end for;
      end for;
    end for;
  else
    for i in 1:nVs[1] loop
      for j in 1:nVs[2] loop
        for k in 1:nFM_3 loop
          Q_flows_3[i, j, k] = 0;
        end for;
      end for;
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifference_1O;
