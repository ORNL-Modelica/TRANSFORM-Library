within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Alphas "Specify Heat Transfer Coefficient (alpha)"

  extends PartialSinglePhase;

  input SI.CoefficientOfHeatTransfer alpha0=0 "Coefficient of heat transfer"
    annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alphas0[nSurfaces]=fill(alpha0, nSurfaces)
    "if non-uniform then set" annotation (Dialog(group="Inputs"));

equation

  for i in 1:nSurfaces loop
    alphas[i] = alphas0[i];
    Nus[i] = alphas[i]*dimension/mediaProps.lambda;
  end for;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas;
