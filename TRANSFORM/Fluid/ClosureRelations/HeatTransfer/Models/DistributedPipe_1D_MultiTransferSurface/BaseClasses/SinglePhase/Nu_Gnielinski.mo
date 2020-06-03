within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase;
model Nu_Gnielinski "Gnielinski"
  extends PartialHeatTransferCorrelation;

  Real f "Friction factor (Darcy)";

equation
  f = (0.79*log(Re)-1.64)^(-2);
  Nu = (f/8)*(Re-1000)*Pr/(1+12.7*(f/8)^0.5*(Pr^(2/3)-1));

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_Gnielinski;
