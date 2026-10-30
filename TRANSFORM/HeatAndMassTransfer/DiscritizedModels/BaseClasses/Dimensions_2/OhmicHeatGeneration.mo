within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
model OhmicHeatGeneration
  extends PartialInternalHeatGeneration;
  input SI.Current I=0 "Current through material"
    annotation (Dialog(group="Inputs"));
  input SI.Current Is[nVs[1],nVs[2]]=fill(
      I,
      nVs[1],
      nVs[2]) "if non-uniform then set Is"
    annotation (Dialog(group="Inputs"));
  SI.Resistance R[nVs[1],nVs[2]] "Electrical resistance";
  SI.Resistivity rho_e[nVs[1],nVs[2]]=Material.electricalResistivity(states)
    "Electrical resistivity";
equation
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      R[i, j] = rho_e[i, j]*lengths_1[i, j]*4/(crossAreas_1[i, j] +
        crossAreas_1[i + 1, j] + crossAreas_2[i, j] + crossAreas_2[i, j + 1]);
      Q_flows[i, j] = R[i, j]*Is[i, j]^2;
    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OhmicHeatGeneration;
