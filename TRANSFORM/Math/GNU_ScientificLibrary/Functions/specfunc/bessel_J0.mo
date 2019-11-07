within TRANSFORM.Math.GNU_ScientificLibrary.Functions.specfunc;
function bessel_J0
  "Bessel function of the 1st kind (regular cylindrical) of order 0"
  extends Modelica.Icons.Function;

input Real x;
output Real y;

external "C" y=gsl_sf_bessel_J0(x) annotation(Library="gsl");
  annotation (Documentation(info="<html>
<p><span style=\"font-family: Times New Roman; background-color: #ffffff;\">These routines compute the regular cylindrical Bessel function of zeroth order,&nbsp;<i>J_0(x)</i>.</span></p>
</html>"));
end bessel_J0;
