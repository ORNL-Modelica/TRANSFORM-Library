within TRANSFORM.Math.Easing.Circular;
model test

  Real pos "Returned value for x-deltax >= 0";
  Real neg "Returned value for x+deltax <= 0";
  Real x "Function argument";
  Real deltax=1 "Region around x with spline interpolation";

  output Real y;
protected
  Real t;
  Real y_int;

algorithm

  t := x/deltax + 0.5;

  if t <= 0.0 then
    y_int := 0.0;
  elseif t >= 1.0 then
    y_int := 1.0;
  else
    if t < 0.5 then
      y_int := (t)^3/2;
    else
      y_int := 1 - ((1 - t))^3/2;
    end if;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test;
