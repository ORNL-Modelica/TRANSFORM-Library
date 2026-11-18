within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Sphere "Radial sphere conduction resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Length r_in "Inner radius, 0 for a solid sphere" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs"));
equation
  R = if r_in > 0 then 1/(4*pi*lambda)*(1/r_in - 1/r_out) else 1/(8*pi*lambda*r_out);
  annotation (defaultComponentName="sphere",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Sphere.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Conduction resistance of a sphere in the radial direction.</p>
<ul>
<li>With <code>r_in = 0</code> the sphere is solid, and <code>R</code> joins its center temperature to its surface temperature for heat generated uniformly inside it.</li>
</ul>
</html>"));
end Sphere;
