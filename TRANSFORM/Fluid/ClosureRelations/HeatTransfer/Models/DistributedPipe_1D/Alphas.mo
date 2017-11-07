within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
model Alphas "Specify Heat Transfer Coefficient (alpha)"

  extends PartialSinglePhase;

  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Input Variables"));
  input SI.CoefficientOfHeatTransfer alphas0[nHT]=fill(alpha0, nHT)
    "if non-uniform then set" annotation (Dialog(group="Input Variables"));

equation

  alphas = alphas0;
  //Nus = alphas.*dimensions./mediums_film.lambda;
  Nus =alphas .* dimensions ./ mediaProps.lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas;
