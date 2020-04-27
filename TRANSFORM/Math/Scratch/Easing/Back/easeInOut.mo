within TRANSFORM.Math.Scratch.Easing.Back;
function easeInOut
  extends PartialEasing;

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
    y_int := if scaledX < 0.0 then (a*(2*(scaledX+0.5))^3 + b*(2*(scaledX+0.5))^2 + c)/2 else (-(a*(-2*(scaledX-0.5))^3 + b*(-2*(scaledX-0.5))^2 + c)+1)/2+0.5;
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeInOut;
