within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Cylinder "Cylinder | Radial"
  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  import Modelica.Math.log;
  import Modelica.Constants.pi;
  input SI.Length L "Cylinder length" annotation(Dialog(group="Inputs"));
  input SI.Length r_in "Inner radius" annotation(Dialog(group="Inputs"));
  input SI.Length r_out "Outer radius" annotation(Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs"));
equation
  R = if r_in>0 then log(r_out/r_in)/(2*pi*L*lambda) else 1/(4*pi*L*lambda);
  annotation (defaultComponentName="cylinder",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Cylinder.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cylinder;
