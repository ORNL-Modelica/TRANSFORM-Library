within TRANSFORM.Math.Scratch.Easing.Cubic;
function splice
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";

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
    y_int := TRANSFORM.Math.Scratch.Easing.Cubic.easeInOut(t);
  end if;

  y := pos*y_int + (1 - y_int)*neg;
end splice;
