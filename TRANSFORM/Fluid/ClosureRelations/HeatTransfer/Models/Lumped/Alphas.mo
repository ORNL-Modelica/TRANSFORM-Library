within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Alphas "Specify Heat Transfer Coefficient (alpha)"

  extends PartialSinglePhase;

  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Inputs"));

equation

  alpha = alpha0;
  Nu =alpha .* dimension ./ mediaProps.lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas;
