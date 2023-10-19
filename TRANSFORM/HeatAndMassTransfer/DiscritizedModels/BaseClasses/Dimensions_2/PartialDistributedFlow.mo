within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2;
partial model PartialDistributedFlow
  "Base class for distributed 2-D flow models"
  replaceable package Material =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nVs[2](each min=1) = {1,1} "Number of discrete volumes"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nFM_1(each min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nFM_2(each min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  parameter Boolean adiabaticDims[2]={false,false}
    "=true, toggle off conduction heat transfer in dimension {1,2}"
    annotation (Dialog(tab="Internal Interface"));
  // Inputs provided to the model
  input Material.ThermodynamicState states_1[nFM_1 + 1,nVs[2]]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input Material.ThermodynamicState states_2[nVs[1],nFM_2 + 1]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Area crossAreas_1[nFM_1,nVs[2]]
    "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Area crossAreas_2[nVs[1],nFM_2]
    "Cross sectional area of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Length lengths_1[nFM_1,nVs[2]] "Length of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Length lengths_2[nVs[1],nFM_2] "Length of heat transfer"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  // Variables defined by model
  output SI.HeatFlowRate Q_flows_1[nFM_1,nVs[2]]
    "Heat flow rate across interfaces" annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  output SI.HeatFlowRate Q_flows_2[nVs[1],nFM_2]
    "Heat flow rate across interfaces" annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  SI.Temperature Ts_1[nFM_1 + 1,nVs[2]] "Temperature at nodal interfaces";
  SI.Temperature Ts_2[nVs[1],nFM_2 + 1] "Temperature at nodal interfaces";
  SI.ThermalConductivity lambdas_1[nFM_1 + 1,nVs[2]] "Thermal conductivity";
  SI.ThermalConductivity lambdas_2[nVs[1],nFM_2 + 1] "Thermal conductivity";
equation
  Ts_1 = Material.temperature(states_1);
  Ts_2 = Material.temperature(states_2);
  lambdas_1 = Material.thermalConductivity(states_1);
  lambdas_2 = Material.thermalConductivity(states_2);
  annotation (Documentation(info="<html>
</html>"), Icon(graphics={Bitmap(extent={{-114,-100},{114,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dTdx.jpg")}));
end PartialDistributedFlow;
