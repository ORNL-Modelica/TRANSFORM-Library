within TRANSFORM.Utilities.CharacteristicNumbers;
function SchmidtNumber "Returns Schmidt Number"
  extends Modelica.Icons.Function;

  input SI.DynamicViscosity mu "Dynamic viscosity";
  input SI.Density d "Density";
  input SI.DiffusionCoefficient D_ab "Diffusion coefficient";

  output Units.nonDim Sc "Schmidt number";
algorithm
  Sc := mu./(d.*D_ab);

  annotation (Documentation(info="<html>
<ul>
<li></li>
</ul>
</html>"));
end SchmidtNumber;
