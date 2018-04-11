within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Cylinder "Cylinder | Radial"

  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;

  import Modelica.Math.log;
  import Modelica.Constants.pi;

  input SI.Length L "Cylinder length" annotation(Dialog(group="Inputs"));
  input SI.Length r_in "Inner radius" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.DiffusionCoefficient D_ab[nC] "Diffusion coefficient" annotation(Dialog(group="Inputs"));

equation

  R = log(r_out/r_in)./(2*pi*L*D_ab);

  annotation (defaultComponentName="cylinder",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Cylinder.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder;
