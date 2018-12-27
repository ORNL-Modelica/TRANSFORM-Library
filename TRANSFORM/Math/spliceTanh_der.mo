within TRANSFORM.Math;
function spliceTanh_der "Derivative of spliceTanh"
  extends Modelica.Icons.Function;
  input Real pos;
  input Real neg;
  input Real x;
  input Real deltax=1;
  input Real dpos;
  input Real dneg;
  input Real dx;
  input Real ddeltax=0;
  output Real y;
protected
  Real scaledX;
  Real scaledX1;
  Real dscaledX1;
  Real y_int;
algorithm
  scaledX1 := x/deltax;
  scaledX := scaledX1*Modelica.Math.asin(1);
  dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
  if scaledX1 <= -0.99999999999 then
    y_int := 0;
  elseif scaledX1 >= 0.9999999999 then
    y_int := 1;
  else
    y_int := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
  end if;
  y := dpos*y_int + (1 - y_int)*dneg;
  if (abs(scaledX1) < 1) then
    y := y + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
      Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
      scaledX))^2;
  end if;
  annotation (Documentation(info="<html>
<p>Derivative of spliceTanh. See spliceTanh.</p>
</html>"));
end spliceTanh_der;
