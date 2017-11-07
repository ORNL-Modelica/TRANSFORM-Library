within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Plane "Plane Wall"

  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;

  input SI.Length L "Wall thickness parallel to heat flow" annotation(Dialog(group="Input Variables"));
  input SI.Area crossArea "Cross-sectional area perpindicular to heat flow" annotation(Dialog(group="Input Variables"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Input Variables"));

equation

  R = L/(lambda*crossArea);

  annotation (defaultComponentName="plane",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Plane.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Plane;
