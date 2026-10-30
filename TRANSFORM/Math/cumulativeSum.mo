within TRANSFORM.Math;
function cumulativeSum
  extends TRANSFORM.Icons.Function;
  input Real u[:];
  output Real y[size(u, 1)];
protected
  Integer n=size(u, 1);
algorithm
  y[1] := u[1];
  for i in 2:n loop
    y[i] := y[i - 1] + u[i];
  end for;
  annotation (Documentation(info="<html>
<p>Calculates a cumulative sum of an array:</p>
<p><br>Example:</p><p><br>input u = {0.2,0.2,0.2,0.2,0.2};</p>
<p>output y = {0.2,0.4,0.6,0.8,1.0}</p>
</html>"));
end cumulativeSum;
