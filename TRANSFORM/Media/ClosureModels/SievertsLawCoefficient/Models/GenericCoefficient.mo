within TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models;
model GenericCoefficient
extends PartialSievertsLawCoefficient;
  input Real kS0=0 "Sievert's Law Coefficient [mol/(m3.Pa^(0.5)]"
    annotation (Dialog(group="Inputs"));
  input Real kSs0[nC]=fill(kS0,nC) "Sievert's Law Coefficient [mol/(m3.Pa^(0.5)]"
    annotation (Dialog(group="Inputs"));
equation
  kSs = kSs0;
    annotation (Dialog(group="Inputs"),
              defaultComponentName="sievertsLawCoeff",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericCoefficient;
