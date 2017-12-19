within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
partial model PartialDistributedFlow
  "Base class for distributed 1-D flow models"

  replaceable package Material =
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true,Dialog(tab="Internal Interface"));

  parameter Integer nVs[1](min=1) = {1} "Number of discrete volumes"
    annotation (Dialog(tab="Internal Interface"));

  parameter Integer nFM_1(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));

  // Inputs provided to the model
  input Material.ThermodynamicState states_1[nFM_1 + 1]
    "Temperature at nodal interfaces"
    annotation (Dialog(group="Input Variables",tab="Internal Interface"));

  input SI.Area crossAreas_1[nFM_1] "Cross sectional area of heat transfer"
    annotation (Dialog(group="Input Variables",tab="Internal Interface"));

  input SI.Length lengths_1[nFM_1] "Length of heat transfer"
    annotation (Dialog(group="Input Variables",tab="Internal Interface"));

  // Variables defined by model
  output SI.HeatFlowRate Q_flows_1[nFM_1] "Heat flow rate across interfaces" annotation(Dialog(group="Output Variables", tab="Internal Interface",enable=false));

  SI.Temperature Ts_1[nFM_1 + 1] "Temperature at nodal interfaces";

  SI.ThermalConductivity lambdas_1[nFM_1 + 1] "Thermal conductivity";

equation
  Ts_1 = Material.temperature(states_1);

  lambdas_1 = Material.thermalConductivity(states_1);
  annotation (Documentation(info="<html>
</html>"), Icon(graphics={Bitmap(extent={{-114,-100},{114,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dTdx.jpg")}));
end PartialDistributedFlow;
