within TRANSFORM.Utilities.CharacteristicNumbers;
function DiffusiveMassTimeConstant
  "Returns time constant for diffusive mass transfer"
  extends Modelica.Icons.Function;
  input SI.DiffusionCoefficient D_ab "Diffusion coefficient";
  input SI.Length L "Characteristic length";
  output SI.Time tau "Diffusive mass transfer time constant";
algorithm
  tau :=0.25*L^2/D_ab;
  annotation (Documentation(info="<html>
<p>Defined to be the approximate time for a thermal wave to penetrate distant L.</p>
<ul>
<li>tau = L^2/(4*alpha_d)</li>
</ul>
</html>"));
end DiffusiveMassTimeConstant;
