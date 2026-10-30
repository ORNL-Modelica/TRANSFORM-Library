within TRANSFORM.Math;
function interpolate_wLimit "Interpolate in a vector"
  input Real x[:]
    "Abscissa table vector (strict monotonically increasing values required)";
  input Real y[size(x, 1)] "Ordinate table vector";
  input Real xi "Desired abscissa value";
  input Integer iLast=1 "Index used in last search";
  input Boolean useBound = false "= true then value outside bounds are constant";
  output Real yi "Ordinate value corresponding to xi";
  output Integer iNew=1 "xi is in the interval x[iNew] <= xi < x[iNew+1]";
algorithm
   (yi,iNew) :=Modelica.Math.Vectors.interpolate(
    x,
    y,
    xi,
    iLast);
   if useBound then
    yi :=if xi < x[1] then y[1] elseif xi > x[end] then y[end] else yi;
  end if;
  annotation (Documentation(info="<html>
<p>Extension of the Modelica.Math.Vectors.interpolate to allow a hard limit at the bounds of the input data.</p>
</html>"));
end interpolate_wLimit;
