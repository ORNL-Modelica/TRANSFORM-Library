within TRANSFORM.Utilities.CharacteristicNumbers;
function PrandtlNumber "Returns Prandtl Number"
  extends Modelica.Icons.Function;
  input SI.DynamicViscosity mu "Dynamic viscosity";
  input SI.SpecificHeatCapacity cp "Constant pressure specific heat capacity";
  input SI.ThermalConductivity lambda "Thermal conductivity";
  output SI.PrandtlNumber Pr "Prandtl number";
algorithm
  Pr := mu.*cp./lambda;
  annotation (Documentation(info="<html>
<ul>
<li></li>
</ul>
</html>"));
end PrandtlNumber;
