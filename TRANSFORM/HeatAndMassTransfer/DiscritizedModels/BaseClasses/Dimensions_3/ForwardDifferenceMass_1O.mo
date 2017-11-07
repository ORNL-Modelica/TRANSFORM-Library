within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model ForwardDifferenceMass_1O
  extends Dimensions_3.PartialDistributedMassFlow;

equation

  if adiabaticDims[1] == false then
    for ic in 1:nC loop
      for i in 1:nFM_1 loop
        for j in 1:nVs[2] loop
          for k in 1:nVs[3] loop
            n_flows_1[i, j, k, ic] = -0.5*(D_abs_1[i, j, k, ic] + D_abs_1[i + 1,
              j, k, ic])*crossAreas_1[i, j, k]*(Cs_1[i + 1, j, k, ic] - Cs_1[i,
              j, k, ic])/lengths_1[i, j, k];
          end for;
        end for;
      end for;
    end for;
  else
    for ic in 1:nC loop
      for i in 1:nFM_1 loop
        for j in 1:nVs[2] loop
          for k in 1:nVs[3] loop
            n_flows_1[i, j, k, ic] = 0;
          end for;
        end for;
      end for;
    end for;
  end if;
  if adiabaticDims[2] == false then
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nFM_2 loop
          for k in 1:nVs[3] loop
            n_flows_2[i, j, k, ic] = -0.5*(D_abs_2[i, j, k, ic] + D_abs_2[i, j
               + 1, k, ic])*crossAreas_2[i, j, k]*(Cs_2[i, j + 1, k, ic] - Cs_2
              [i, j, k, ic])/lengths_2[i, j, k];
          end for;
        end for;
      end for;
    end for;
  else
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nFM_2 loop
          for k in 1:nVs[3] loop
            n_flows_2[i, j, k, ic] = 0;
          end for;
        end for;
      end for;
    end for;
  end if;
  if adiabaticDims[3] == false then
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nVs[2] loop
          for k in 1:nFM_3 loop
            n_flows_3[i, j, k, ic] = -0.5*(D_abs_3[i, j, k, ic] + D_abs_3[i, j,
              k + 1, ic])*crossAreas_3[i, j, k]*(Cs_3[i, j, k + 1, ic] - Cs_3[i,
              j, k, ic])/lengths_3[i, j, k];
          end for;
        end for;
      end for;
    end for;
  else
    for ic in 1:nC loop
      for i in 1:nVs[1] loop
        for j in 1:nVs[2] loop
          for k in 1:nFM_3 loop
            n_flows_3[i, j, k, ic] = 0;
          end for;
        end for;
      end for;
    end for;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ForwardDifferenceMass_1O;
