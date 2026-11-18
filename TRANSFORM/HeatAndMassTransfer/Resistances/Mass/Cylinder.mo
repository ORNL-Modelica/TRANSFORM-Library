within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Cylinder "Radial cylinder diffusion resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;
  import Modelica.Math.log;
  import Modelica.Constants.pi;
  input SI.Length L "Cylinder length" annotation(Dialog(group="Inputs"));
  input SI.Length r_in "Inner radius, 0 for a solid cylinder" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.DiffusionCoefficient D_ab[nC] "Diffusion coefficient" annotation(Dialog(group="Inputs"));
equation
  R = if r_in > 0 then log(r_out/max(r_in, Modelica.Constants.small))./(2*pi*L*D_ab) else 1.0./(4*pi*L*D_ab);
  annotation (defaultComponentName="cylinder",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Cylinder.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Diffusion resistance of a cylinder in the radial direction.</p>
<ul>
<li>With <code>r_in = 0</code> the cylinder is solid, and <code>R</code> joins its centerline concentration to its surface concentration for a substance generated uniformly inside it.</li>
</ul>
</html>"));
end Cylinder;
