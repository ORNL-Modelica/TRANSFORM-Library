within TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models;
model GenericCoefficient

extends PartialMassDiffusionCoefficient;

  input SI.DiffusionCoefficient D_ab0=Modelica.Constants.eps "Diffusion Coefficient"
    annotation (Dialog(group="Input Variables"));
  input SI.DiffusionCoefficient D_abs0[nC]=fill(D_ab0,nC) "if non-uniform then set"
    annotation (Dialog(group="Input Variables"));

equation

  D_abs = D_abs0;

  annotation (defaultComponentName = "massDiffusionCoeff",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericCoefficient;
