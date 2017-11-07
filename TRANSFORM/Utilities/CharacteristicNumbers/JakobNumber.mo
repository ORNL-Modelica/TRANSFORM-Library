within TRANSFORM.Utilities.CharacteristicNumbers;
function JakobNumber "Returns Jakob number"
  extends Modelica.Icons.Function;

  input SI.SpecificHeatCapacity cp "Specific heat capacity";
  input SI.Temperature T_s "Surface temperature";
  input SI.Temperature T_sat "Saturation temperature";
  input SI.SpecificEnthalpy h_fg "Latent heat of vaporization";

  output Units.nonDim Ja "Jakob number";
algorithm
  Ja := cp.*abs(T_s-T_sat)./h_fg;

  annotation (Documentation(info="<html>
<p>Defined to be the ratio of sensible to latent energy absorbed during liquid-vapor phase change.</p>
<ul>
<li>Ja = cp*(Ts-Tsat)/h_fg</li>
</ul>
</html>"));
end JakobNumber;
