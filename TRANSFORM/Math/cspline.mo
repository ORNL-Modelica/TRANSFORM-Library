within TRANSFORM.Math;
function cspline
  extends TRANSFORM.Icons.Function;
  input Real x0 "Abscissa value of interest";
  input Real x[:] "Abscissa array";
  input Real y[size(x,1)] "Ordinate array";
  input Real d[size(x,1)] "Derivative of at data points. Use d = splineDerivatives()";
  output Real result "Interpolated ordinate value";
protected
    Integer i "Integer to select data interval";
algorithm
  i := 1;
  for j in 1:size(x, 1) - 1 loop
    if x0 > x[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  result := TRANSFORM.Math.cubicHermiteSplineLinearExtrapolation(
    x=x0,
    x1=x[i],
    x2=x[i + 1],
    y1=y[i],
    y2=y[i + 1],
    y1d=d[i],
    y2d=d[i + 1]);
  annotation(smoothOrder=3);
end cspline;
