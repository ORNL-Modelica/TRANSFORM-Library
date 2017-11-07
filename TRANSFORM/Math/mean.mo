within TRANSFORM.Math;
function mean
  extends Modelica.Icons.Function;

  input Real x[:];
  output Real y;

protected
  Integer n = size(x,1);

algorithm

  y :=sum(x)/n;

end mean;
