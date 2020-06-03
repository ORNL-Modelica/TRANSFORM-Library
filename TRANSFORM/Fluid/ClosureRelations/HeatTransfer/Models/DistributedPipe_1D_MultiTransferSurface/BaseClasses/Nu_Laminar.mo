within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses;
model Nu_Laminar "Laminar"
  extends PartialHeatTransferCorrelation;

equation
  Nu = 4.36;
  alpha = Nu*lambda/L_char;
  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_Laminar;
