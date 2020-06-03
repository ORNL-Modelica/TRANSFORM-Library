within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_SinglePhase_2Region_modelBased
  "Specify Nus | Single Phase | 2 Region"
  extends PartialSinglePhase_modelBased;

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));

  replaceable model Nus_region1 =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase.Nu_Laminar
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase.PartialHeatTransferCorrelation
    "Nusselt number region 1 (e.g., laminar)" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer Correlation"));

  replaceable model Nus_region2 =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase.Nu_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase.PartialHeatTransferCorrelation
    "Nusselt number region 2 (e.g., turbulent)" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer Correlation"));

   Nus_region1 nus_region1[nHT,nSurfaces](
     redeclare package Medium = Medium,
     Re={{Res[i] for j in 1:nSurfaces} for i in 1:nHT},
     Pr={{Prs[i] for j in 1:nSurfaces} for i in 1:nHT},
     mediaProps={{mediaProps_internal[i] for j in 1:nSurfaces} for i in 1:nHT},
     state_wall=states_wall);

  Nus_region2 nus_region2[nHT,nSurfaces](
    redeclare package Medium = Medium,
    Re={{Res[i] for j in 1:nSurfaces} for i in 1:nHT},
    Pr={{Prs[i] for j in 1:nSurfaces} for i in 1:nHT},
    mediaProps={{mediaProps_internal[i] for j in 1:nSurfaces} for i in 1:nHT},
    state_wall=states_wall);

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = TRANSFORM.Math.spliceTanh(
        nus_region2[i, j].Nu,
        nus_region1[i, j].Nu,
        Res[i] - Re_center,
        Re_width);
    end for;
  end for;

  alphas = Nus .* lambda ./ L_char;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region_modelBased;
