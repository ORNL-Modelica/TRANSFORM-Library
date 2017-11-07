within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record Ts1D

  parameter Integer ns[1](min=1)={1} "Number of nodes in each dimesions {1}";

  parameter SI.Temperature T_a1_start = 273.15 "Temperature at port a1"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Temperature T_b1_start=T_a1_start "Temperature at port b1"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));

  parameter SI.Temperature Ts_start[ns[1]]= fill((T_a1_start+T_b1_start)/2,ns[1])
         "Temperatures {port_a1,...,port_b1}"
    annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ts1D;
