within TRANSFORM.Math.Easing.Elastic;
function easeInOut "Elastic | Ease In & Out"
  extends PartialEasing;

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
