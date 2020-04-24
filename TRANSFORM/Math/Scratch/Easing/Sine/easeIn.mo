within TRANSFORM.Math.Scratch.Easing.Sine;
function easeIn
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";

  output Real y;
protected
  Real scaledX =  x/deltax;
  Real y_int;

algorithm
  if scaledX <= -0.999999999 then
    y_int := 0;
  elseif scaledX >= 0.999999999 then
    y_int := 1;
  else
    y_int := 1-cos((scaledX+1)*Modelica.Constants.pi/4);
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeIn;
