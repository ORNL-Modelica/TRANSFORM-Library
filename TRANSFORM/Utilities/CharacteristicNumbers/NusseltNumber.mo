within TRANSFORM.Utilities.CharacteristicNumbers;
function NusseltNumber "Return Nusselt number"
  extends Modelica.Icons.Function;
  input SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  input SI.Length D "Characteristic dimension";
  input SI.ThermalConductivity lambda "Thermal conductivity";
  output SI.NusseltNumber Nu "Nusselt number";
algorithm
  Nu := alpha.*D./lambda;
  annotation (Documentation(info="Nusselt number Nu = alpha*D/lambda"));
end NusseltNumber;
