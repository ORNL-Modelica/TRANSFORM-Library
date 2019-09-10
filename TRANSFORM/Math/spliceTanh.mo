within TRANSFORM.Math;
function spliceTanh
  "Spline interpolation of two functions using the hyperbolic tangent"
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";
  output Real y;
protected
  Real scaledX;
  Real scaledX1;
  Real y_int;
algorithm
  scaledX1 := x/deltax;
  scaledX := scaledX1*Modelica.Math.asin(1);
  if scaledX1 <= -0.999999999 then
    y_int := 0;
  elseif scaledX1 >= 0.999999999 then
    y_int := 1;
  else
    y_int := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
  end if;
  y := pos*y_int + (1 - y_int)*neg;
  annotation (smoothOrder=1,derivative=spliceTanh_der,
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceTanh.jpg\"/></p>
</html>"));
end spliceTanh;
