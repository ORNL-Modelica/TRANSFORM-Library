within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
model OhmicHeatGeneration
  extends PartialInternalHeatGeneration;
  input SI.Current I = 0 "Current through material" annotation(Dialog(group="Inputs"));
  input SI.Current Is[nVs[1]] = fill(I,nVs[1]) "if non-uniform then set Is" annotation(Dialog(group="Inputs"));
  SI.Resistance R[nVs[1]] "Electrical resistance";
  SI.Resistivity rho_e[nVs[1]] = Material.electricalResistivity(states) "Electrical resistivity";
equation
  for i in 1:nVs[1] loop
    R[i] = rho_e[i]*lengths_1[i]*2/(crossAreas_1[i] + crossAreas_1[i+1]);
    Q_flows[i] = R[i]*Is[i]^2;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OhmicHeatGeneration;
