within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
partial model PartialDistributedMassFlow
  "Base class for distributed 3-D flow models"
  replaceable package Material =
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true,Dialog(tab="Internal Interface"));
  parameter Integer nVs[3](min=1) = {1,1,1} "Number of discrete volumes"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nFM_1(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nFM_2(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nFM_3(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nC = 1 "Number of diffusive substances" annotation (Dialog(tab="Internal Interface"));
  parameter Boolean adiabaticDims[3]={false,false,false}
    "=true, toggle off diffusive mass transfer in dimension {1,2,3}"
    annotation (Dialog(tab="Internal Interface"));
  // Inputs provided to the model
  input Material.ThermodynamicState states_1[nFM_1 + 1,nVs[2],nVs[3]]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input Material.ThermodynamicState states_2[nVs[1],nFM_2 + 1,nVs[3]]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input Material.ThermodynamicState states_3[nVs[1],nVs[2],nFM_3 + 1]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Concentration Cs_1[nFM_1 + 1,nVs[2],nVs[3],nC] "Concentration at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Concentration Cs_2[nVs[1],nFM_2 + 1,nVs[3],nC] "Concentration at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Concentration Cs_3[nVs[1],nVs[2],nFM_3 + 1,nC] "Concentration at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Area crossAreas_1[nFM_1,nVs[2],nVs[3]]
    "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Area crossAreas_2[nVs[1],nFM_2,nVs[3]]
    "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Area crossAreas_3[nVs[1],nVs[2],nFM_3]
    "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_1[nFM_1,nVs[2],nVs[3]] "Length of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_2[nVs[1],nFM_2,nVs[3]] "Length of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_3[nVs[1],nVs[2],nFM_3] "Length of heat transfer"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.DiffusionCoefficient D_abs_1[nFM_1 + 1,nVs[2],nVs[3],nC] "Diffusion coefficient"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.DiffusionCoefficient D_abs_2[nVs[1],nFM_2 + 1,nVs[3],nC] "Diffusion coefficient"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.DiffusionCoefficient D_abs_3[nVs[1],nVs[2],nFM_3 + 1,nC] "Diffusion coefficient"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  // Variables defined by model
  output SI.MolarFlowRate n_flows_1[nFM_1,nVs[2],nVs[3],nC] "Molar flow rate across interfaces"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  output SI.MolarFlowRate n_flows_2[nVs[1],nFM_2,nVs[3],nC] "Molar flow rate across interfaces"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  output SI.MolarFlowRate n_flows_3[nVs[1],nVs[2],nFM_3,nC] "Molar flow rate across interfaces"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  annotation (Documentation(info="<html>
</html>"), Icon(graphics={Bitmap(extent={{-114,-100},{114,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dTdx.jpg")}));
end PartialDistributedMassFlow;
