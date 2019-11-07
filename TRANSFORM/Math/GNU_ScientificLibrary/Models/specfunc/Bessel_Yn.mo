within TRANSFORM.Math.GNU_ScientificLibrary.Models.specfunc;
model Bessel_Yn
  extends TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses.PartialBessel;

equation
  y = Functions.specfunc.bessel_Yn(n, x);
  annotation (Icon(graphics={Text(
          extent={{-66,20},{72,-14}},
          lineColor={0,0,0},
          textString="Y(n,x)")}));
end Bessel_Yn;
