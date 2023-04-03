within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions;
record DistributedVolume_solid1D
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.Material_solid;
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses.Ts1D(
      T_a1_start=Material.T_reference);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DistributedVolume_solid1D;
