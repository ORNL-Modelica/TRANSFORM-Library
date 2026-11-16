within TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models;
model GenericCoefficient
extends PartialHenrysLawCoefficient;
  input SItf.HenrysLawCoefficient kH0=0 "Henry's Law Coefficient"
    annotation (Dialog(group="Inputs"));
  input SItf.HenrysLawCoefficient kHs0[nC]=fill(kH0, nC)
    "if non-uniform then set" annotation (Dialog(group="Inputs"));
equation
  kHs = kHs0;
  annotation (defaultComponentName="henrysLawCoeff",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericCoefficient;
