within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
model Nus_SinglePhase_2Region "Specify Nus | Single Phase | 2 Region - Laminar & Turbulent"

  extends PartialSinglePhase;

  input SI.NusseltNumber[nHT] Nus_lam=
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res,
      Prs,
      xs,
      dimensions,
      true) "Laminar Nusselt number"
    annotation (Dialog(group="Input Variables"));

  input SI.NusseltNumber[nHT] Nus_turb=
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res,
      Prs,
      xs,
      dimensions,
      roughnesses) "Turbulent Nusselt number"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT] L_char=dimensions
    "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT] lambda=mediaProps.lambda
    "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nHT loop
  Nus[i] =  TRANSFORM.Math.spliceTanh(
    Nus_turb[i],
    Nus_lam[i],
    Res[i] - Re_center,
    Re_width);
end for;

  alphas = Nus.*lambda./L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region;
