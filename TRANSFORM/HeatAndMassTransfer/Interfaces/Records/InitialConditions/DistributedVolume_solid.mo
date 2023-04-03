within TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions;
record DistributedVolume_solid
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.Material_solid;
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.BaseClasses.Ts(
      T_a_start=Material.T_reference);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DistributedVolume_solid;
