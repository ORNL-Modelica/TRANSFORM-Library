within TRANSFORM.Obsolete.Math.GNU_ScientificLibrary.Functions.specfunc;
function bessel_Kn
  "Modified bessel function of the 2nd kind (irregular modified cylindrical) of order n"
  extends Modelica.Icons.Function;

input Integer n;
input Real x;
output Real y;

algorithm
  y := TRANSFORM.Math.besselK(abs(n), x);
  annotation (obsolete="Obsolete function - use TRANSFORM.Math.besselK instead",Documentation(info="<html>
<p><span style=\"font-family: Times New Roman; background-color: #ffffff;\">These routines compute the regular cylindrical Bessel function of order&nbsp;<i>n</i>,&nbsp;<i>J_n(x)</i>.</span></p>
</html>"));
end bessel_Kn;
