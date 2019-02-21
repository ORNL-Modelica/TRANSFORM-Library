within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PhaseInterface;
model Alphas "Specify Heat Transfer Coefficient (alpha)"
  extends PartialPhaseInterface;
  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Inputs"));
equation
  alpha = alpha0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas;
