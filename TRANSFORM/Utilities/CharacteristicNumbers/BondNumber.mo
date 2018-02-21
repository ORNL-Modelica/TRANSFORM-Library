within TRANSFORM.Utilities.CharacteristicNumbers;
function BondNumber "Returns Bond number"
  extends Modelica.Icons.Function;

  input SI.Acceleration g_n "Gravitational constant";
  input SI.Density rho_l "Liquid density";
  input SI.Density rho_v "Vapor density";
  input SI.Length L "Characteristic length";
  input SI.SurfaceTension sigma "Surface tension";

  output Units.NonDim Bo "Bond number";
algorithm
  Bo := g_n.*(rho_l-rho_v).*L.*L./sigma;

  annotation (Documentation(info="<html>
<p>Defined to be the ratio of an internal resistance to an external resistance.</p>
<p>In the context of the&nbsp;thermal fluids, it is ratio of gravitational and surface tension forces.</p>
<ul>
<li>Bo = g*(rho_l-rho_v)*L^2/sigma</li>
</ul>
</html>"));
end BondNumber;
