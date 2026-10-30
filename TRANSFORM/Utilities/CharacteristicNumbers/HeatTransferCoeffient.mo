within TRANSFORM.Utilities.CharacteristicNumbers;
function HeatTransferCoeffient
  "Return heat transfer coefficient from Nusselt number"
  extends Modelica.Icons.Function;
  input SI.NusseltNumber Nu "Nusselt number";
  input SI.Length D "Characteristic dimension";
  input SI.ThermalConductivity lambda "Thermal conductivity";
  output SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
algorithm
  alpha := Nu*lambda/D;
  annotation (Documentation(info="Nusselt number Nu = alpha*D/lambda"));
end HeatTransferCoeffient;
