within TRANSFORM.Math;
function clamp
  extends TRANSFORM.Icons.Function;
  import Modelica.Math;
  input Real x "Value";
  input Real min "Minimum value below which x val holds as x = min";
  input Real max "Maximum value above which x val holds as x = min";
  output Real y "Result";
algorithm
    if (x < min) then
        y :=min;
    elseif (x > max) then
        y :=max;
    else
      y :=x;
    end if;
   annotation (smoothOrder=1, Documentation(info="<html>
<p>Limit the output to within a min/max boundary.</p>
<p><br><br>Source:</p>
<ul>
<li><a href=\"http://iquilezles.org/www/articles/smin/smin.htm\">https://en.wikipedia.org/wiki/Clamping_(graphics)</a></li>
</ul>
</html>"));
end clamp;
