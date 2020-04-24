within TRANSFORM.Math.Scratch.Easing.Elastic;
function easeInOut
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";

  output Real y;
protected
  Real scaledX =  x/deltax;
  Real y_int;

  Real a = 2*Modelica.Constants.pi/3;
algorithm
  if scaledX <= -0.999999999 then
    y_int := 0;
  elseif scaledX >= 0.999999999 then
    y_int := 1;
  else
    y_int := if scaledX < 0.0 then -2^(20 * (scaledX+0.5) - 10) * sin(((scaledX+0.5) * 20 - 10.75) * a)/2 else (2^(-20 * (scaledX-0.5) - 10) * sin((-(scaledX-0.5) * 20 - 10.75) * a)+1)/2 +0.5;
  end if;
  y := pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1);
end easeInOut;
