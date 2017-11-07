within TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models;
model GenericCoefficient

extends PartialHenrysLawCoefficient;

  input TRANSFORM.Units.HenrysLawCoefficient kH0=0 "Henry's Law Coefficient"
    annotation (Dialog(group="Input Variables"));
  input TRANSFORM.Units.HenrysLawCoefficient kHs0[nC]=fill(kH0, nC)
    "if non-uniform then set" annotation (Dialog(group="Input Variables"));

equation

  kHs = kHs0;

  annotation (defaultComponentName="henrysLawCoeff",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericCoefficient;
