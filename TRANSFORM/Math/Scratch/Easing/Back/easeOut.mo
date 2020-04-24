within TRANSFORM.Math.Scratch.Easing.Back;
function easeOut
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";

  output Real y;
protected
  Real scaledX =  x/deltax;
  Real y_int;

  Real a = 0.5;
  Real b = 0.75;
  Real c = -0.25;
algorithm
  if scaledX <= -0.999999999 then
    y_int := 0;
  elseif scaledX >= 0.999999999 then
    y_int := 1;
  else
    y_int := -(a*(-scaledX)^3 + b*(-scaledX)^2 + c)+1;
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeOut;
