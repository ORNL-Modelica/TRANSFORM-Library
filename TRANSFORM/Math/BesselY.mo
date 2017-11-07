within TRANSFORM.Math;
function BesselY
  extends Modelica.Icons.Function;

  import TRANSFORM.Math.BesselJ;

  input Real k "Bessel order";
  input Real x "Value in Jk(x)";
  input Real tolerance = 1e-6 "tolerance for infinite sum termination";

  output Real Yk "Bessel function Jk(x) (order k) value";

algorithm

//   if mod(abs(k),1) <> 0 then
//     Yk :=(BesselJ(
//       k=k,
//       x=x,
//       tolerance=tolerance)*cos(pi*k) - BesselJ(
//       k=-k,
//       x=x,
//       tolerance=tolerance))/sin(pi*k);
//   else
    //Yk = 1/pi*dJkdk(k=k,x=x)+(-1)^k/pi*dJkdx(k=k,x=x)

  annotation (Documentation(info="<html>
<p>An implementation of Kreisselmeier Steinhauser smooth maximum</p>
</html>"));
end BesselY;
