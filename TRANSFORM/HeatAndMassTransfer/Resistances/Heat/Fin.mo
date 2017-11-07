within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Fin "Fin"

  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;

  input SI.Efficiency eta "Fin efficiency" annotation(Dialog(group="Input Variables"));
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Input Variables"));
  input SI.CoefficientOfHeatTransfer alpha "Convection heat transfer coefficient" annotation(Dialog(group="Input Variables"));

equation

  R = 1/(eta*alpha*surfaceArea);

  annotation (defaultComponentName="convection",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Fin.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fin;
