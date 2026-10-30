within TRANSFORM.Math;
function regStep
  "Approximation of a general step, such that the approximation is continuous and differentiable"
  extends TRANSFORM.Icons.Function;
  input Real pos "Ordinate value for x > 0";
  input Real neg "Ordinate value for x < 0";
  input Real x "Abscissa value";
  input Real deltax(min=0) = 1e-5
    "Approximation of step for -deltax <= x <= deltax; deltax >= 0 required";
  output Real y "Ordinate value to approximate y = if x > 0 then y1 else y2";
algorithm
  y :=smooth(1, if x > deltax then pos else if x < -deltax then neg else if
    deltax > 0 then (x/deltax)*((x/deltax)^2 - 3)*(neg - pos)/4 + (pos + neg)/2
     else (pos + neg)/2);
  annotation (smoothOrder=4,Inline=true, Documentation(info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region <code>-x_small &lt; x &lt; x_small</code> a 2nd order polynomial is used
for a smooth transition from <code>y1</code> to <code>y2</code>.
</p>
</html>"));
end regStep;
