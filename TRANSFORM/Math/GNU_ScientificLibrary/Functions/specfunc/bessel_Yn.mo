within TRANSFORM.Math.GNU_ScientificLibrary.Functions.specfunc;
function bessel_Yn
  "Bessel function of the 2nd kind (irregular cylindrical) of order n"
  extends Modelica.Icons.Function;

input Integer n;
input Real x;
output Real y;

external "C" y=gsl_sf_bessel_Yn(n,x) annotation(Library="gsl");
  annotation (Documentation(info="<html>
<p><span style=\"font-family: Times New Roman; background-color: #ffffff;\">These routines compute the regular cylindrical Bessel function of order&nbsp;<i>n</i>,&nbsp;<i>J_n(x)</i>.</span></p>
</html>"));
end bessel_Yn;
