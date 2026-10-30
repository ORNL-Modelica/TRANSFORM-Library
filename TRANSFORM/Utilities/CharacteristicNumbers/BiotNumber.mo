within TRANSFORM.Utilities.CharacteristicNumbers;
function BiotNumber "Returns Biot number"
  extends Modelica.Icons.Function;
  input SI.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";
  input SI.Length L "Characteristic length";
  input SI.ThermalConductivity lambda "Thermal conductivity (e.g., of the solid)";
  output Units.NonDim Bi "Biot number";
algorithm
  Bi :=alpha*L/lambda;
  annotation (Documentation(info="<html>
<p>Defined to be the ratio of an internal resistance to an external resistance.</p>
<p>In the context of species or&nbsp;mass transfer, it is the ratio of the internal species transfer resistance to the boundary layer species transfer resistance. </p>
<ul>
<li>Bi = alpha_m*L/D_ab</li>
</ul>
<p>In the context of the&nbsp;thermal fluids, it is ratio of the internal thermal resistance of a solid to the boundary layer thermal resistance.</p>
<ul>
<li>Bi = alpha*L/lambda</li>
</ul>
</html>"));
end BiotNumber;
