within TRANSFORM.Utilities.CharacteristicNumbers;
function KnudsenNumber "Returns Knudsen number"
  extends Modelica.Icons.Function;

  input SI.Length L_ms "Distance between energy carrier interactions";
  input SI.Length L_char "Length scale that characterizes the problem";

  output Units.nonDim Kn "Jakob number";
algorithm
  Kn := L_ms/L_char;

  annotation (Documentation(info="<html>
<p>Defined to be the ratio of the length scale between interactions divied by the characteristic length scale of the problem</p>
<ul>
<li>Kn = L_ms/L_char</li>
</ul>
<p>If Kn is not &LT;&LT; 1 then continuum theory breaks down and the calculus assumption to derive dT/dx as the lim dx -&GT; 0 is not valid.</p>
<p>This limit may be reached in micro and nano-scale systems where L_char becomes small as well as in problems involving rarefied gas where L+ms becomes large.</p>
</html>"));
end KnudsenNumber;
