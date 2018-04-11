within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
partial model PartialDistributedMassFlow
  "Base class for distributed 1-D mass flow models"

  replaceable package Material =
  TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  parameter Integer nVs[1](min=1) = {1} "Number of discrete volumes"
    annotation (Dialog(tab="Internal Interface"));

  parameter Integer nFM_1(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nC = 1 "Number of diffusive substances" annotation (Dialog(tab="Internal Interface"));

  // Inputs provided to the model
  input Material.ThermodynamicState states_1[nFM_1 + 1]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));

  input SI.Concentration Cs_1[nFM_1 + 1,nC] "Concentration at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  input SI.Area crossAreas_1[nFM_1] "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  input SI.Length lengths_1[nFM_1] "Length of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  input SI.DiffusionCoefficient D_abs_1[nFM_1 + 1,nC] "Diffusion coefficient"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  // Variables defined by model
  output SI.MolarFlowRate n_flows_1[nFM_1,nC] "Molar flow rate across interfaces"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));

  annotation (Documentation(info="<html>
</html>"), Icon(graphics={Bitmap(extent={{-114,-100},{114,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dCdx.jpg")}));
end PartialDistributedMassFlow;
