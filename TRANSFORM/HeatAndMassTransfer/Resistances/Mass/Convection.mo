within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Convection "Convective mass transfer resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Mass transfer surface area"
    annotation (Dialog(group="Inputs"));
  input SItf.CoefficientOfMassTransfer alphaM[nC]
    "Mass transfer coefficient" annotation (Dialog(group="Inputs"));
equation
  R = 1.0./(alphaM*surfaceArea);
    annotation (defaultComponentName="convection",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Convection.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Convective mass transfer resistance between a surface and a fluid, for a mass transfer coefficient <code>alphaM</code> that the user gives. <code>ConvectionMedia</code> instead computes the coefficients with a mass transfer model chosen from a list and the fluid's properties.</p>
</html>"));
end Convection;
