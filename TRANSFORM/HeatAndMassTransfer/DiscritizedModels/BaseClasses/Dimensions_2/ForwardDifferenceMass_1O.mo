within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model ForwardDifferenceMass_1O
  extends PartialDistributedMassFlow;
equation
  if adiabaticDims[1] == false then
    for ic in 1:nC loop
      for i in 1:nFM_1 loop
        for j in 1:nVs[2] loop
          n_flows_1[i, j, ic] = -0.5*(D_abs_1[i, j, ic] + D_abs_1[i + 1, j, ic])
            *crossAreas_1[i, j]*(Cs_1[i + 1, j, ic] - Cs_1[i, j, ic])/lengths_1
            [i, j];
        end for;
      end for;
    end for;
  else
    for ic in 1:nC loop
      for i in 1:nFM_1 loop
        for j in 1:nVs[2] loop
          n_flows_1[i, j, ic] = 0;
        end for;
      end for;
    end for;
  end if;
  if adiabaticDims[2] == false then
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nFM_2 loop
          n_flows_2[i, j, ic] = -0.5*(D_abs_2[i, j, ic] + D_abs_2[i, j + 1, ic])
            *crossAreas_2[i, j]*(Cs_2[i, j + 1, ic] - Cs_2[i, j, ic])/lengths_2
            [i, j];
        end for;
      end for;
    end for;
  else
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nFM_2 loop
          n_flows_2[i, j, ic] = 0;
        end for;
      end for;
    end for;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifferenceMass_1O;
