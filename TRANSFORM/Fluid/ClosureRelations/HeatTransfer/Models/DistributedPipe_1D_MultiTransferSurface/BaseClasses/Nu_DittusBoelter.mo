within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses;
model Nu_DittusBoelter "Dittus-Boelter"
  extends PartialHeatTransferCorrelation;

  input Real A = 0.023 "Multiplication value" annotation(Dialog(group="Inputs"));
  input Real gamma = 0.8 "Exponent to Reynolds number" annotation(Dialog(group="Inputs"));
  input Real beta = 0.4 "Exponent to Prandtl number" annotation(Dialog(group="Inputs"));

equation
  Nu = A*Re^gamma*Pr^beta;
  alpha = Nu*lambda/L_char;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_DittusBoelter;
