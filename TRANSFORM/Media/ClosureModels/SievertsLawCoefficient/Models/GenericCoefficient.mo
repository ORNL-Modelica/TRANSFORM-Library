within TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models;
model GenericCoefficient

extends PartialSievertsLawCoefficient;

  input Real kS0=0 "Sievert's Law Coefficient [mol/(m3.Pa^(0.5)]"
    annotation (Dialog(group="Inputs"));

equation

  kS = kS0;

  annotation (defaultComponentName="sievertsLawCoeff",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericCoefficient;
