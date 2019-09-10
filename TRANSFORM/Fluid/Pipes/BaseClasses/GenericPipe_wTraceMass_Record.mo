within TRANSFORM.Fluid.Pipes.BaseClasses;
record GenericPipe_wTraceMass_Record
  import TRANSFORM;
  extends GenericPipe_Record;
  // Trace Mass Transfer Model
  parameter Boolean use_TraceMassTransfer=false "= true to use the TraceMassTransfer model"
    annotation (Dialog(group="Trace Mass Transfer"));
  replaceable model TraceMassTransfer =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D.PartialMassTransfer_setC
    "Trace Substance mass transfer" annotation (Dialog(group="Trace Mass Transfer", enable=
          use_TraceMassTransfer), choicesAllMatching=true);
  // Internal Trace Substance Generation Model
  replaceable model InternalTraceGen =
      TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.PartialInternalTraceGeneration
                                                "Internal trace mass generation" annotation (Dialog(
        group="Trace Mass Transfer"), choicesAllMatching=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericPipe_wTraceMass_Record;
