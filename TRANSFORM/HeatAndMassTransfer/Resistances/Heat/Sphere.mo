within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Sphere "Sphere | Radial"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Length r_in "Inner radius" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs"));
equation
  R = 1/(4*pi*lambda)*(1/r_in - 1/r_out);
  annotation (defaultComponentName="sphere",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Sphere.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sphere;
