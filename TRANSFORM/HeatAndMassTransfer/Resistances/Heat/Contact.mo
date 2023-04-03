within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Contact "Contact | Interfacial resistance"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Inputs"));
  input SI.ThermalInsulance Rc_pp "Area specific contact resistance" annotation(Dialog(group="Inputs"));
equation
  R = Rc_pp/surfaceArea;
  annotation (defaultComponentName="contact",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Contact.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Contact;
