within TRANSFORM.Utilities.CharacteristicNumbers;
function LumpedHeatTimeConstant
  "Returns time constant for lumped heat volume"
  extends Modelica.Icons.Function;
  input SI.ThermalResistance R "Total thermal resistance";
  input SI.HeatCapacity C "Thermal capacitance";
  output SI.Time tau "Diffusive heat transfer time constant";
algorithm
  tau := R*C;
  annotation (Documentation(info="<html>
<p>Defined to be the approximate time for a thermal wave to penetrate distant L.</p>
<ul>
<li>tau = L^2/(4*alpha_d)</li>
</ul>
</html>"));
end LumpedHeatTimeConstant;
