within TRANSFORM.Math;
function interpolate2D "Interpolate a 2D data table"
  input Real x[:]
    "x-abscissa table vector (strict monotonically increasing values required)";
  input Real y[:] "y-abscissa table vector (strict monotonically increasing values required)";
  input Real data[size(x,1),size(y,1)] "Ordinate data table with size(x) rows and size(y) columns";
  input Real xi "Desired x-abscissa value";
  input Real yi "Desired y-abscissa value";
  input Boolean useBound = false "= true then value outside bounds are constant";
  output Real val "Ordinate value corresponding to (xi,yi)";
output Real[size(x,1)] temp;
protected
    Integer N = size(x,1);
    Real data_red[N] "Reduced data set after first interpolation";
algorithm
  for i in 1:N loop
  data_red[i] :=TRANSFORM.Math.interpolate_wLimit(
      y,
      data[i, :],
      yi,
      1,
      useBound);
  end for;
  temp :=data_red;
  val :=TRANSFORM.Math.interpolate_wLimit(
    x,
    data_red,
    xi,
    1,
    useBound);
  annotation (Documentation(info="<html>
<p>2-D interpolation with option for hard limit on the dimensions.</p>
</html>"));
end interpolate2D;
