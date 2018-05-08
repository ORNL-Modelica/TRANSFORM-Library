within TRANSFORM.Math;
function integral_TrapezoidalRule "Integral of array y(x) using the trapezoidal rule"

  extends Modelica.Icons.Function;

  input Real[:] x "dependent array";
  input Real[size(x,1)] y "independent array";

  output Real integral "Resulting integral";

protected
  Integer n = size(x,1);
  Real[n-1] dx;

algorithm
  integral := 0;

  for i in 1:n-1 loop
    dx[i] := x[i+1] - x[i];
    integral := integral + 0.5*dx[i]*(y[i+1]+y[i]);
  end for;

end integral_TrapezoidalRule;
