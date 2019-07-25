within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
partial model PartialInternalHeatGeneration
  replaceable package Material =
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material properties" annotation (choicesAllMatching=true,Dialog(tab="Internal Interface"));
  parameter Integer nVs[3](min=1) = {1,1,1} "Number of discrete volumes"
    annotation(Dialog(tab="Internal Interface"));
  // Inputs provided to the model
  input Material.ThermodynamicState states[nVs[1],nVs[2],nVs[3]]
    "Volume thermodynamic state"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Volume Vs[nVs[1],nVs[2],nVs[3]] "Volumes"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Area crossAreas_1[nVs[1]+1,nVs[2],nVs[3]] "Volume cross sectional area"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Area crossAreas_2[nVs[1],nVs[2]+1,nVs[3]] "Volume cross sectional area"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Area crossAreas_3[nVs[1],nVs[2],nVs[3]+1] "Volume cross sectional area"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_1[nVs[1],nVs[2],nVs[3]] "Volume length"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_2[nVs[1],nVs[2],nVs[3]] "Volume length"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  input SI.Length lengths_3[nVs[1],nVs[2],nVs[3]] "Volume length"
    annotation (Dialog(group="Inputs",tab="Internal Interface"));
  // Variables defined by model
  output SI.HeatFlowRate Q_flows[nVs[1],nVs[2],nVs[3]] "Internal heat generated" annotation(Dialog(group="Outputs", tab="Internal Interface",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-120,-100},{120,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/ClosureModel_Qgen.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialInternalHeatGeneration;
