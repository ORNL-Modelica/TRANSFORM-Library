within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
model Alphas "Specify Heat Transfer Coefficient"
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialSinglePhase;
  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alphas0[nHT]=fill(alpha0, nHT)
    "if non-uniform then set" annotation (Dialog(group="Inputs"));
equation
  alphas = alphas0;
  Nus = alphas.*dimensions./mediums_film.lambda;
  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Alphas;
