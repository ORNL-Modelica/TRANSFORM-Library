within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_SinglePhase_2Region "Specify Nus | Single Phase | 2 Region - Laminar & Turbulent"

  extends PartialSinglePhase;

  input SI.NusseltNumber[nHT,nSurfaces] Nus_lam=
      {{HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      true) for j in 1:nSurfaces} for i in 1:nHT} "Laminar Nusselt number"
    annotation (Dialog(group="Input Variables"));

  input SI.NusseltNumber[nHT,nSurfaces] Nus_turb=
      {{HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      roughnesses[i]) for j in 1:nSurfaces} for i in 1:nHT} "Turbulent Nusselt number"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:nSurfaces})
    "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Input Variables"));

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = TRANSFORM.Math.spliceTanh(
        Nus_turb[i,j],
        Nus_lam[i,j],
        Res[i] - Re_center,
        Re_width);
    end for;
  end for;

  alphas = Nus.*lambda./L_char;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region;
