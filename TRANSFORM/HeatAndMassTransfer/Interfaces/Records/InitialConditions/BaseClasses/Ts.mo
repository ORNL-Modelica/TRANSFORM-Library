within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses;
record Ts

  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.nodes;
  extends
    TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses.T_ab;

  parameter SI.Temperature[n] Ts_start=
      if n > 1 then
         linspace(T_a_start,T_b_start,n)
      else
        {(T_a_start+T_b_start)/2} "Temperatures {port_a,...,port_b}"
    annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ts;
