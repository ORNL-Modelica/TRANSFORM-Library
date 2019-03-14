within TRANSFORM.Math.Scratch;
function splicetestsefe
  "Spline interpolation of two functions using the hyperbolic tangent"
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";
  input Real curvature = 0.5 "Smoothing curvature. <0.5 = increasingly concave, >0.5 incresingly convex";
  output Real y;
protected
  Real scaledX1;
  //Real scaledX1;

  Real y_int;
  Real P[3];
algorithm
  P[1] :=neg;
  P[2] :=pos*curvature + (1 - curvature)*neg;
  P[3] :=pos;

  scaledX1 := x/deltax+0.5;
  //scaledX := scaledX1*Modelica.Math.asin(1);

  if scaledX1 <= 0.000000001 then
    y_int := neg;
  elseif scaledX1 >= 0.999999999 then
    y_int := pos;
  else
    y_int := (1 - scaledX1)^2*P[1] + 2*(1 - scaledX1)*scaledX1*P[2] + scaledX1^2*P[3];
  end if;

y := neg+y_int;//pos*y_int + (1 - y_int)*neg;

  annotation (smoothOrder=1,derivative=spliceTanh_der,
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceTanh.jpg\"/></p>
</html>"));
end splicetestsefe;
