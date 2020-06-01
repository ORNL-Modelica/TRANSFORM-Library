within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Nus_SinglePhase_2Region_modelbased
  "Specify Nus | Single Phase | 2 Region - Laminar & Turbulent"
  extends PartialSinglePhase;
  extends TRANSFORM.Icons.UnderConstruction;


  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));

  replaceable model Nus_lam =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.Nu_Laminar
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.PartialHeatTransferCorrelation
    annotation (choicesAllMatching=true,Dialog(group="Heat Transfer Correlation"));

  replaceable model Nus_turb =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.Nu_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.PartialHeatTransferCorrelation
    annotation (choicesAllMatching=true,Dialog(group="Heat Transfer Correlation"));

  Nus_lam nus_lam[nHT,nSurfaces](
    Re = {{Res[i] for j in 1:nSurfaces} for i in 1:nHT},
    Pr = {{Prs[i] for j in 1:nSurfaces} for i in 1:nHT},
    L_char = L_char,
    lambda = lambda);

  Nus_turb nus_turb[nHT,nSurfaces](
    Re = {{Res[i] for j in 1:nSurfaces} for i in 1:nHT},
    Pr = {{Prs[i] for j in 1:nSurfaces} for i in 1:nHT},
    L_char = L_char,
    lambda = lambda);

equation
  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      Nus[i, j] = TRANSFORM.Math.spliceTanh(
        nus_turb[i, j].Nu,
        nus_lam[i, j].Nu,
        Res[i] - Re_center,
        Re_width);
    end for;
  end for;
  alphas = Nus .* lambda ./ L_char;
  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region_modelbased;
