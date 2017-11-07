within TRANSFORM.Utilities.CharacteristicNumbers;
function LewisNumber "Returns Lewis Number"
  extends Modelica.Icons.Function;

  input Units.nonDim Sc "Schmidt number";
  input SI.PrandtlNumber Pr "Prandtl number";

  output Units.nonDim Le "Lewis number";
algorithm
  Le := Sc./Pr;

  annotation (Documentation(info="<html>
<ul>
<li></li>
</ul>
</html>"));
end LewisNumber;
