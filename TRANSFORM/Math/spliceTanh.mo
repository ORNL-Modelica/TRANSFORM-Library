within TRANSFORM.Math;
function spliceTanh
  "Spline interpolation of two functions using the hyperbolic tangent"
  extends Modelica.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";
  output Real out;
protected
  Real scaledX;
  Real scaledX1;
  Real y;
algorithm
  scaledX1 := x/deltax;
  scaledX := scaledX1*Modelica.Math.asin(1);
  if scaledX1 <= -0.999999999 then
    y := 0;
  elseif scaledX1 >= 0.999999999 then
    y := 1;
  else
    y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
  end if;
  out := pos*y + (1 - y)*neg;
  annotation (smoothOrder=1,derivative=spliceTanh_der);
end spliceTanh;
