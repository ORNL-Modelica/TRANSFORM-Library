within TRANSFORM.Utilities.CharacteristicNumbers;
function DiffusiveHeatTimeConstant
  "Returns time constant for diffusive heat transfer"
  extends Modelica.Icons.Function;

  input SI.ThermalDiffusivity alpha_d "Thermal diffusivity";
  input SI.Length L "Characteristic length";

  output SI.Time tau "Diffusive heat transfer time constant";
algorithm
  tau :=0.25*L^2/alpha_d;

  annotation (Documentation(info="<html>
<p>Defined to be the approximate time for a thermal wave to penetrate distant L.</p>
<ul>
<li>tau = L^2/(4*alpha_d)</li>
</ul>
</html>"));
end DiffusiveHeatTimeConstant;
