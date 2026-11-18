within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Sphere "Radial sphere diffusion resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;
  input SI.Length r_in "Inner radius" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.DiffusionCoefficient D_ab[nC] "Diffusion coefficient" annotation(Dialog(group="Inputs"));
equation
  R = 1.0./(4*pi*D_ab)*(1/r_in - 1/r_out);
  annotation (defaultComponentName="sphere",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Sphere.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Diffusion resistance of a spherical shell in the radial direction.</p>
</html>"));
end Sphere;
