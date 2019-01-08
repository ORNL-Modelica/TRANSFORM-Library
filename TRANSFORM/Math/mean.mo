within TRANSFORM.Math;
function mean
  extends TRANSFORM.Icons.Function;

  input Real x[:];
  output Real y;

protected
  Integer n = size(x,1);

algorithm

  y :=sum(x)/n;

  annotation (Documentation(info="<html>
<p>Returns the mean or average of the array</p>
<p>y = sum(x)/n where n is length of x array</p>
</html>"));
end mean;
