within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
model Shs_SinglePhase_Overall "Specify Shs | Single Phase | 2 Region - Laminar & Turbulent"
  extends PartialSinglePhase;
  input SI.SchmidtNumber Shs_lam[nMT,Medium.nC]={
      HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.InternalFlow.Sh_Laminar_Local_Developed_Circular_SiederTate(
      Res[i],
      Scs[i, j],
      sum(dlengths),
      dimensions[i]) for j in 1:Medium.nC,i in 1:nMT} "Laminar Schmidt number"
    annotation (Dialog(group="Inputs"));
  input SI.SchmidtNumber Shs_turb[nMT,Medium.nC]={
      HeatAndMassTransfer.ClosureRelations.MassTransfer.Functions.SinglePhase.InternalFlow.Sh_Turbulent_Local_Developed_Circular_DittusBoelter(
      Res[i], Scs[i, j]) for j in 1:Medium.nC,i in 1:nMT}
    "Turbulent Schmidt number" annotation (Dialog(group="Inputs"));
  input SI.Length[nMT] L_char=dimensions
    "Characteristic dimension for calculation of alphaM"
    annotation (Dialog(group="Inputs"));
equation
  for i in 1:nMT loop
    Shs[i, :] = TRANSFORM.Math.spliceTanh(
      Shs_turb[i, :],
      Shs_lam[i, :],
      Res[i] - Re_center,
      Re_width);
  end for;
  for i in 1:nMT loop
    alphasM[i, :] =Shs[i, :] .*diffusionCoeff[i].D_abs ./ L_char[i];
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Shs_SinglePhase_Overall;
