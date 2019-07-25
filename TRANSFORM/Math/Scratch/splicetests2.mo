within TRANSFORM.Math.Scratch;
function splicetests2
  "Spline interpolation of two functions using the hyperbolic tangent"
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";
  input Real curvature = 0.5 "Smoothing curvature. <0.5 = increasingly concave, >0.5 incresingly convex";
  output Real y;
  output Real bar;
protected
  Real scaledX1;
  //Real scaledX1;

  Real y_int;
  Real P[4];
algorithm
  P[1] :=0.0;
  P[2] :=curvature;
  P[3] := 0.75;
  P[4] :=1.0;

  scaledX1 := x/deltax;
  //scaledX := scaledX1*Modelica.Math.asin(1);

  if scaledX1 <= -0.999999999 then
    y_int := 0;
  elseif scaledX1 >= 0.999999999 then
    y := 1;
  else
    y_int := (1 - scaledX1^3)*P[1] + 3*scaledX1*(1 - scaledX1)^2*P[2] + 3*scaledX1^2*(1 - scaledX1)*P[3] + scaledX1^3*P[4];
  end if;

  y := pos*y_int + (1 - y_int)*neg;
  bar :=y_int;
  annotation (smoothOrder=1,derivative=spliceTanh_der,
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceTanh.jpg\"/></p>
</html>"));
end splicetests2;
