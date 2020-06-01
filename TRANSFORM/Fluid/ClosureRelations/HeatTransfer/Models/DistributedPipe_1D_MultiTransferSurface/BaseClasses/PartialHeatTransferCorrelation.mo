within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses;
partial model PartialHeatTransferCorrelation

  extends TRANSFORM.Icons.UnderConstruction;

  input SI.ReynoldsNumber Re "Reynolds number" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.PrandtlNumber Pr "Prandtl number" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.Length L_char annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.ThermalConductivity lambda annotation(Dialog(tab="Internal Interface",group="Inputs"));

  output SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer" annotation(Dialog(tab="Internal Interface",group="Outputs"));
  output SI.NusseltNumber Nu "Nusselt number" annotation(Dialog(tab="Internal Interface",group="Outputs"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransferCorrelation;
