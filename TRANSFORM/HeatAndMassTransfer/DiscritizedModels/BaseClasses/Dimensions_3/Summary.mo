within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
record Summary
  extends Icons.Record;
  SI.Temperature T_effective "Unit cell mass averaged temperature"
    annotation (Dialog(group="Inputs"));
  SI.Temperature T_max "Maximum temperature" annotation (Dialog(group="Inputs"));
  SI.ThermalConductivity lambda_effective "Unit cell mass averaged thermal conductivity" annotation (Dialog(group="Inputs"));
  annotation (
    defaultComponentName="summary",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
