within TRANSFORM.Obsolete.Math.GNU_ScientificLibrary.Functions.specfunc;
function bessel_J0
  "Bessel function of the 1st kind (regular cylindrical) of order 0"
  extends Modelica.Icons.Function;

input Real x;
output Real y;

algorithm
  y := TRANSFORM.Math.besselJ(0, x);
  annotation (obsolete="Obsolete function - use TRANSFORM.Math.besselJ(0, x) instead",Documentation(info="<html>
<p><span style=\"font-family: Times New Roman; background-color: #ffffff;\">These routines compute the regular cylindrical Bessel function of zeroth order,&nbsp;<i>J_0(x)</i>.</span></p>
</html>"));
end bessel_J0;
