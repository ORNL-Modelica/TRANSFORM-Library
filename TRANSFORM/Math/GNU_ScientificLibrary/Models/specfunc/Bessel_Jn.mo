within TRANSFORM.Math.GNU_ScientificLibrary.Models.specfunc;
model Bessel_Jn
  extends TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses.PartialBessel;

equation
  y = Functions.specfunc.bessel_Jn(n, x);
  annotation (Icon(graphics={Text(
          extent={{-74,20},{74,-10}},
          lineColor={0,0,0},
          textString="J(n,x)")}));
end Bessel_Jn;
