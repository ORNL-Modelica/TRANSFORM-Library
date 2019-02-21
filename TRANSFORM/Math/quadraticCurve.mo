within TRANSFORM.Math;
function quadraticCurve
  "Quadratic curve, including linear extrapolation beyond defined curve limits"
  extends Icons.Function;
  input Real x "abscissa value of interest";
  input Real[3] x_curve "Three points that define the abscissa curve";
  input Real[3] y_curve "Three points that define the ordinate curve";
  output Real y "Ordinate output at x";
protected
  Real[3] c=quadraticCoefficients(x_curve, y_curve)
    "Coefficients of quadratic power consumption curve";
  Real x_min=min(x_curve);
  Real x_max=max(x_curve);
  Real slope_21=(y_curve[2] - y_curve[1])/(x_curve[2] - x_curve[1]);
  Real slope_32=(y_curve[3] - y_curve[2])/(x_curve[3] - x_curve[2]);
algorithm
  if slope_32 > slope_21 then
    if x < x_min then
      y := min(y_curve) + (x - x_max)*(c[2] + 2*c[3]*x_max);
    elseif x > x_max then
      y := max(y_curve) + (x - x_min)*(c[2] + 2*c[3]*x_min);
    else
      y := c[1] + c[2]*x + c[3]*x*x;
    end if;
    y := max(0.0, y);
  else
    if x < x_min then
      y := max(y_curve) + (x - x_min)*(c[2] + 2*c[3]*x_min);
    elseif x > x_max then
      y := min(y_curve) + (x - x_max)*(c[2] + 2*c[3]*x_max);
    else
      y := c[1] + c[2]*x + c[3]*x*x;
    end if;
  end if;
end quadraticCurve;
