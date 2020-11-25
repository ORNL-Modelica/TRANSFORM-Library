within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase;
model Nu_Laminar "Laminar"
  extends PartialHeatTransferCorrelation;

equation
  Nu = 4.36;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_Laminar;
