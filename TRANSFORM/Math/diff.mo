within TRANSFORM.Math;
function diff
  extends Modelica.Icons.Function;
  input Real u[:] "Scalar array";
  output Real y[size(u, 1) - 1];

algorithm
  for i in 1:size(u, 1) - 1 loop
    y[i] := u[i + 1] - u[i];
  end for;

end diff;
