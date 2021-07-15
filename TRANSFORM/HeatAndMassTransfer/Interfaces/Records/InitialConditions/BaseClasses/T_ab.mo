within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record T_ab
  parameter SI.Temperature T_a_start
      "Temperature at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Temperature T_b_start=T_a_start
      "Temperature at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end T_ab;
