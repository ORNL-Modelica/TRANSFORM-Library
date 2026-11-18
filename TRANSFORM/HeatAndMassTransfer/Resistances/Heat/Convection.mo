within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Convection "Convective heat transfer resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alpha "Convection heat transfer coefficient" annotation(Dialog(group="Inputs"));
equation
  R = 1/(alpha*max(Modelica.Constants.eps,surfaceArea));
  annotation (defaultComponentName="convection",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Convection.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Convection resistance between a surface and a fluid, for a heat transfer coefficient <code>alpha</code> that the user gives. <code>ConvectionMedia</code> instead computes the coefficient with a heat transfer model chosen from a list and the fluid's properties.</p>
</html>"));
end Convection;
