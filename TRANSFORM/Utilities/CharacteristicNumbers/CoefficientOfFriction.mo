within TRANSFORM.Utilities.CharacteristicNumbers;
function CoefficientOfFriction "Returns Coefficient of Friction"
  extends Modelica.Icons.Function;

  input SI.ShearStress tau_s "Shear stress";
  input SI.Density rho "Density";
  input SI.Velocity v "Velocity";

  output Units.nonDim Cf "Coefficient of friction";
algorithm
  Cf := tau_s./(0.5*rho.*v.*v);

  annotation (Documentation(info="<html>
<p>Defined to be the dimensionless shear stress.</p>
<ul>
<li>Cf = tau_s/(rho*v^2/2)</li>
</ul>
</html>"));
end CoefficientOfFriction;
