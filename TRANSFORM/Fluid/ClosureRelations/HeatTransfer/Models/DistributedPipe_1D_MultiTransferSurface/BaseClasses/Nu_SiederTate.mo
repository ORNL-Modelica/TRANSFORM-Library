within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses;
model Nu_SiederTate "Sieder-Tate"
  extends PartialHeatTransferCorrelation;

  input Real A = 0.027 "Multiplication value" annotation(Dialog(group="Inputs"));
  input Real a = 0.8 "Exponent to Reynolds number" annotation(Dialog(group="Inputs"));
  input Real b = 1/3 "Exponent to Prandtl number" annotation(Dialog(group="Inputs"));
  input Real c = 0.14 "Exponent for viscosity ratio" annotation(Dialog(group="Inputs"));

equation
  Nu = A*Re^a*Pr^b*(mu/mu_wall)^c;
  alpha = Nu*lambda/L_char;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nu_SiederTate;
