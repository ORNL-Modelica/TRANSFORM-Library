within TRANSFORM.Math;
function linspace_1D
  "Create a linearly spaced 1D array and the special case when n = 1 the average is returned"
  extends TRANSFORM.Icons.Function;

  input Real x1 "Corner value x[1]";
  input Real x2 "Corner value x[end]";

  input Integer n "Array size";

  output Real y[n] "Array";

algorithm

  if n == 1 then
    y[1] := 0.5*(x1 + x2);
  else
    y := linspace(
      x1,
      x2,
      n);
  end if;

end linspace_1D;
