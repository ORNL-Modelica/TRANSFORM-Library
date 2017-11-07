within TRANSFORM.Math;
function logspace "Create log spaced vector"

  input Real start "Start value";
  input Real stop "Stop value";
  input Integer n "Number of generated points";

  output Real[n] x "Logarithmically spaced vector";
  output Real[n-1] dx "Spacing between generated points";
protected
  Real t "Scaling value";

algorithm
  assert((start > 0 and stop>0) or (start<0 and stop<0), "Start and stop values must both be greater or less than zero");

  if n == 1 then

    t := 0;
    x[1] := stop;

  else

    t := (stop/start)^(1/(n - 1));

    for i in 1:n loop
      x[i] := start*t^(i - 1);
    end for;

  end if;

  for i in 1:n-1 loop
    dx[i] :=x[i + 1] - x[i];
  end for;

  annotation (Documentation(info="<html>
<p>logspace(start,stop,n) generates a row vector of n logarithmically</p>
<p>equally spaced points between decades start and stop.</p>
<p>For n = 1, logspace returns stop.</p>
</html>"));
end logspace;
