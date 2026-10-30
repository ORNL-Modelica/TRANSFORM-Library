within TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models;
partial model PartialMassDiffusionCoefficient
  parameter Integer nC = 1 "Number of substances" annotation(Dialog(tab="Internal Interface"));
  input SI.Temperature T "Temperature" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  output SI.DiffusionCoefficient D_abs[nC] "Diffusion Coefficient" annotation(Dialog(tab="Internal Interface",group="Outputs",enable=false));
  annotation (defaultComponentName="massDiffusionCoeff",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -102,-100},{102,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/diffusionCoeffient.jpg")}),
                                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMassDiffusionCoefficient;
