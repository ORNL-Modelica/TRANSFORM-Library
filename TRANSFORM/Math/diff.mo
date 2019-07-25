within TRANSFORM.Math;
function diff
  extends TRANSFORM.Icons.Function;
  input Real u[:] "Scalar array";
  output Real y[size(u, 1) - 1];
algorithm
  for i in 1:size(u, 1) - 1 loop
    y[i] := u[i + 1] - u[i];
  end for;
  annotation (Documentation(info="<html>
<p>Calculates the difference between adjacent values in array.</p>
<p>For example:</p>
<p><span style=\"font-family: Courier New;\">u&nbsp;=&nbsp;{1,2,5,10,20};</span></p>
<p><span style=\"font-family: Courier New;\">y = {1,3,5,10};</span></p>
</html>"));
end diff;
