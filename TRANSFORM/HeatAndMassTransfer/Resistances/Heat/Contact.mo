within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Contact "Thermal contact resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Contact area" annotation(Dialog(group="Inputs"));
  input SI.ThermalInsulance Rc_pp "Contact resistance per unit area" annotation(Dialog(group="Inputs"));
equation
  R = Rc_pp/surfaceArea;
  annotation (defaultComponentName="contact",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Contact.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Thermal contact resistance at the interface between two solids that touch.</p>
</html>"));
end Contact;
