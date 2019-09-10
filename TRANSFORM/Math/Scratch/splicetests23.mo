within TRANSFORM.Math.Scratch;
function splicetests23
  "Spline interpolation of two functions using the hyperbolic tangent"
  extends TRANSFORM.Icons.Function;
  input Real pos "Returned value for x-deltax >= 0";
  input Real neg "Returned value for x+deltax <= 0";
  input Real x "Function argument";
  input Real deltax=1 "Region around x with spline interpolation";
  input Real P[:] = {0.0,0.05,0.95,1.0};
  output Real y;
  output Real bar;
protected
  Real scaledX1;
  //Real scaledX1;

  Real y_int;
//   Real P[4];
algorithm
//   P[1] :=0.0;
//   P[2] :=curvature;
//   P[3] := 0.75;
//   P[4] :=1.0;

  scaledX1 := x/deltax+0.5;
  //scaledX := scaledX1*Modelica.Math.asin(1);

  if scaledX1 <= 0.000000001 then
    y_int := neg;
  elseif scaledX1 >= 0.999999999 then
    y := pos;
  else
    if size(P,1) == 4 then
    y_int := (1 - scaledX1^3)*P[1] + 3*scaledX1*(1 - scaledX1)^2*P[2] + 3*scaledX1^2*(1 - scaledX1)*P[3] + scaledX1^3*P[4];
    end if;
  end if;

  y := y_int;//pos*y_int + (1 - y_int)*neg;
  bar :=y_int;
  annotation (smoothOrder=1,
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceTanh.jpg\"/></p>
</html>"));
end splicetests23;
