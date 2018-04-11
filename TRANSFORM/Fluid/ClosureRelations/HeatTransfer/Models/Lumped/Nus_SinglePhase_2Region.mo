within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Nus_SinglePhase_2Region "Specify Nus | Single Phase | 2 Regions"

  extends PartialSinglePhase;

  input SI.NusseltNumber Nus_lam=
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Laminar Nusselt number"
    annotation (Dialog(group="Inputs"));

  input SI.NusseltNumber Nus_turb=
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Turbulent Nusselt number"
    annotation (Dialog(group="Inputs"));

  input SI.Length L_char=dimension
    "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda=mediaProps.lambda
    "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));

equation

  Nu = TRANSFORM.Math.spliceTanh(
        Nus_turb,
        Nus_lam,
        Re - Re_center,
        Re_width);

  alpha = Nu .* lambda ./ L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region;
