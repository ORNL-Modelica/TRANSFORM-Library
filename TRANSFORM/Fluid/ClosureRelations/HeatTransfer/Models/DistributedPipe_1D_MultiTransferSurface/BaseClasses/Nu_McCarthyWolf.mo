within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses;
model Nu_McCarthyWolf "McCarthy-Wolf"
  extends PartialHeatTransferCorrelation;

  input Real A =  0.025 "Multiplication value" annotation(Dialog(group="Inputs"));
  input Real a =  0.8   "Exponent to Reynolds number" annotation(Dialog(group="Inputs"));
  input Real b =  0.4   "Exponent to Prandtl number" annotation(Dialog(group="Inputs"));
  input Real c = -0.55  "Exponent for temperature ratio" annotation(Dialog(group="Inputs"));

equation
  Nu = A*Re^a*Pr^b*(T_wall/T)^c;
  alpha = Nu*lambda/L_char;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_McCarthyWolf;
