within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_SinglePhase_Churchill
  "Specify Nus | Single Phase | Churchill - Laminar & Turbulent"
  extends PartialSinglePhase;
//  input SI.NusseltNumber[nHT,nSurfaces] Nus=
//      {{TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Churchill(
//      Res[i],Prs[i],roughnesses[i],dimensions[i])  for j in 1:nSurfaces} for i in 1:nHT}
  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:nSurfaces})
    "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));
equation
  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Churchill(Res[i],Prs[i],roughnesses[i],dimensions[i]);
    end for;
  end for;
  alphas = Nus.*lambda./L_char;
    annotation (Dialog(group="Inputs"),
              defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_Churchill;
