within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Convection "Convection"
  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;
  input SI.Area surfaceArea "Transfer surface area"
    annotation (Dialog(group="Inputs"));
  input Units.CoefficientOfMassTransfer alphaM[nC]
    "Coefficient of mass transfer" annotation (Dialog(group="Inputs"));
equation
  R = 1.0./(alphaM*surfaceArea);
    annotation (Dialog(group="Inputs"),
    defaultComponentName="convection",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Convection.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Convection;
