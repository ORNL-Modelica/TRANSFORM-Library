within TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models;
partial model PartialHenrysLawCoefficient
  parameter Integer nC = 1 "Number of substances";
  input SI.Temperature T "Temperature"
    annotation (Dialog(group="Inputs"));
  output TRANSFORM.Units.HenrysLawCoefficient kHs[nC] "Henry's Law Coefficient"
    annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  annotation (defaultComponentName="henrysLawCoeff",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -102,-100},{102,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/HenrysLawCoefficient.jpg")}),
                                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHenrysLawCoefficient;
