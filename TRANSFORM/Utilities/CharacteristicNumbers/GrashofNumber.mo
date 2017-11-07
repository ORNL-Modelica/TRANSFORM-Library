within TRANSFORM.Utilities.CharacteristicNumbers;
function GrashofNumber "Returns Grashof number"
  extends Modelica.Icons.Function;

  input SI.Length x "Position for local Gr_x or characteristic surface length Gr_L";
  input SI.PrandtlNumber Pr "Prandtl number";
  input SI.Temperature T_wall "Wall temperature";
  input SI.SpecificHeatCapacity cp "Specific heat capacity";
  input SI.Temperature Ts "Surface temperature";
  input SI.Temperature Tsat "Saturation temperature";
  input SI.SpecificEnthalpy h_fg "Latent heat of vaporization";

  output Units.nonDim Ja "Jakob number";
algorithm
  Ja := cp.*abs(Ts-Tsat)./h_fg;

  annotation (Documentation(info="<html>
<p>Often takes a role in natural convection prcoesses that Reynolds number does in forced convection.</p>
<p>Defined to be the ratio of the buoyancy forces to the viscous forces acting on the fluid.</p>
<ul>
<li>Ja = cp*(Ts-Tsat)/h_fg</li>
</ul>
<p><br>If Gr/Re^2 ~= 1 then free and forced convection must be considered.</p>
<p>If Gr/Re^2 &LT;&LT; 1 then free convection effects may be neglected.</p>
<p>If Gr/Re^2 &GT;&GT; 1 then forced convection effects may be neglected.</p>
</html>"));
end GrashofNumber;
