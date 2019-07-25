within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record T
  parameter SI.Temperature T_start "Temperature"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end T;
