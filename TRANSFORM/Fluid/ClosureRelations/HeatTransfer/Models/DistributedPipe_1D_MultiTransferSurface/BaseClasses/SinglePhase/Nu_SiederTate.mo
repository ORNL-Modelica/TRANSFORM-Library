within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase;
model Nu_SiederTate "Sieder-Tate"
  extends PartialHeatTransferCorrelation;

  input Real A = 0.027 "Multiplication value" annotation(Dialog(group="Inputs"));
  input Real alpha = 0.8 "Exponent to Reynolds number" annotation(Dialog(group="Inputs"));
  input Real beta = 1/3 "Exponent to Prandtl number" annotation(Dialog(group="Inputs"));
  input Real delta = 0.14 "Exponent for viscosity ratio" annotation(Dialog(group="Inputs"));

  SI.DynamicViscosity mu_wall=Medium.dynamicViscosity(state_wall);

equation
  Nu = A*Re^alpha*Pr^beta*(mediaProps.mu/mu_wall)^delta;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_SiederTate;
