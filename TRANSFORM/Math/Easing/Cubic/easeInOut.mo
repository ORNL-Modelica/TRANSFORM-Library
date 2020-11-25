within TRANSFORM.Math.Easing.Cubic;
function easeInOut "Cubic | Ease In & Out"
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
    y_int := if scaledX < 0.0 then (scaledX+1)^3/2 else -(-scaledX+1)^3/2+1;
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeInOut;
