within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record Ts2D

  parameter Integer ns[2](min=1)={1,1} "Number of nodes in each dimesions {1,2}";

  parameter SI.Temperature T_a1_start = 273.15 "Temperature at port a1"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Temperature T_b1_start=T_a1_start "Temperature at port b1"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));

  parameter SI.Temperature T_a2_start = 273.15 "Temperature at port a2"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Temperature T_b2_start=T_a2_start "Temperature at port b2"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));

  parameter SI.Temperature Ts_start[ns[1],ns[2]]= fill((T_a1_start+T_b1_start+T_a2_start+T_b2_start)/4,ns[1],ns[2]) "Temperatures"
    annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ts2D;
