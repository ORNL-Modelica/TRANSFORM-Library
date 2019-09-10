within TRANSFORM.Math.Scratch.Easing;
function easeInOutCubic
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";

  output Real y;
protected
  Real scaledX1;
  Real y_int;

algorithm

  scaledX1 := x/deltax + 0.5;

  if scaledX1 <= 0.0 then
    y_int := 0.0;
  elseif scaledX1 >= 1.0 then
    y_int := 1.0;
  else
    if scaledX1 < 0.5 then
      y_int := (scaledX1)^3/2;
    else
      y_int := 1 - ((1 - scaledX1))^3/2;
    end if;
  end if;

  y := pos*y_int + (1 - y_int)*neg;

  annotation (
    smoothOrder=1,
    derivative=spliceTanh_der,
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceTanh.jpg\"/></p>
</html>"));
end easeInOutCubic;
