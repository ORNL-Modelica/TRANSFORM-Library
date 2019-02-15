within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Convection "Convection"
  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alpha "Convection heat transfer coefficient" annotation(Dialog(group="Inputs"));
equation
  R = 1/(alpha*max(Modelica.Constants.eps,surfaceArea));
  annotation (defaultComponentName="convection",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Convection.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Convection;
