within TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models;
partial model PartialSievertsLawCoefficient

  parameter Integer nC = 1 "Number of substances";

  input SI.Temperature T "Temperature"
    annotation (Dialog(group="Input Variables"));

  output Real kSs[nC] "Sievert's Law Coefficient [mol/(m3.Pa^(0.5)]" annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));

  annotation (defaultComponentName="sievertsLawCoeff",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -102,-100},{102,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/SievertsLawCoefficient.jpg")}),
                                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSievertsLawCoefficient;
