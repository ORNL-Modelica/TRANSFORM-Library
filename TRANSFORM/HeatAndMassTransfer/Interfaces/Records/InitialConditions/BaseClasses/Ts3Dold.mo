within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record Ts3Dold
  parameter Integer ns[3](min=1)={1,1,1} "Number of nodes in each dimesions {1,2,3}";
  parameter SI.Temperature T_ref = 273.15 "Reference temperature for unifrom initialization" annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start[ns[1],ns[2],ns[3]]= fill(T_ref,ns[1],ns[2],ns[3]) "Temperatures"
    annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ts3Dold;
