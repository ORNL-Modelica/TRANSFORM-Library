within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Nus_SinglePhase_2Region "Specify Nus | Single Phase | 2 Regions"

  extends PartialSinglePhase;

  input SI.NusseltNumber[nSurfaces] Nus_lam={4.36 for i in 1:nSurfaces}
    "Laminar Nusselt number" annotation (Dialog(group="Inputs"));

  input SI.NusseltNumber[nSurfaces] Nus_turb={
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
       Re, Pr) for i in 1:nSurfaces} "Turbulent Nusselt number"
    annotation (Dialog(group="Inputs"));

  input SI.Length[nSurfaces] L_char=fill(dimension, nSurfaces)
    "Characteristic dimension for calculation of alpha"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nSurfaces] lambda=fill(mediaProps.lambda,
      nSurfaces) "Thermal conductivity for calculation of alpha"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nSurfaces loop
    Nus[i] = TRANSFORM.Math.spliceTanh(
      Nus_turb[i],
      Nus_lam[i],
      Re - Re_center,
      Re_width);
  end for;

  alphas = Nus .* lambda ./ L_char;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nus_SinglePhase_2Region;
