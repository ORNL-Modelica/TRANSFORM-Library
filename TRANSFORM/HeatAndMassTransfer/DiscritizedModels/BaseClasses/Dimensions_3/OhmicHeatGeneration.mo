within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
model OhmicHeatGeneration

  extends PartialInternalHeatGeneration;

  input SI.Current I=0 "Current through material"
    annotation (Dialog(group="Inputs"));
  input SI.Current Is[nVs[1],nVs[2],nVs[3]]=fill(
      I,
      nVs[1],
      nVs[2],
      nVs[3]) "if non-uniform then set Is"
    annotation (Dialog(group="Inputs"));

  SI.Resistance R[nVs[1],nVs[2],nVs[3]] "Electrical resistance";
  SI.Resistivity rho_e[nVs[1],nVs[2],nVs[3]]=Material.electricalResistivity(
      states) "Electrical resistivity";

equation

  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      for k in 1:nVs[3] loop
        R[i, j, k] = rho_e[i, j, k]*lengths_1[i, j, k]*6/(crossAreas_1[i, j, k]
           + crossAreas_1[i + 1, j, k] + crossAreas_2[i, j, k] + crossAreas_2[i,
          j + 1, k] + crossAreas_3[i, j, k] + crossAreas_3[i, j, k + 1]);
        Q_flows[i, j, k] = R[i, j, k]*Is[i, j, k]^2;
      end for;
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OhmicHeatGeneration;
