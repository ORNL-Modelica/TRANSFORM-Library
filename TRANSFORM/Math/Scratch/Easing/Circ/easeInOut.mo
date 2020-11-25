within TRANSFORM.Math.Scratch.Easing.Circ;
function easeInOut
  extends PartialEasing;

protected
  Real scaledX =  x/deltax;
  Real y_int;

algorithm
  if scaledX <= -0.999999999 then
    y_int := 0;
  elseif scaledX >= 0.999999999 then
    y_int := 1;
  else
    y_int := if scaledX == 0.0 then 0.5 elseif scaledX < 0.0 then 0.5 - 0.5*sqrt(1 - (scaledX+1)^2) else 0.5 +
      0.5*sqrt(1 - (-scaledX + 1)^2);
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeInOut;
