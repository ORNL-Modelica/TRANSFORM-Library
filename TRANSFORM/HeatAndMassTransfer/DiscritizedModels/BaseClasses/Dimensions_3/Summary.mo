within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3;
record Summary

  extends Icons.Record;

  input SI.Temperature T_effective "Unit cell mass averaged temperature"
    annotation (Dialog(group="Input Variables"));
  input SI.Temperature T_max "Maximum temperature" annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity lambda_effective "Unit cell mass averaged thermal conductivity" annotation (Dialog(group="Input Variables"));

  annotation (
    defaultComponentName="summary",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
