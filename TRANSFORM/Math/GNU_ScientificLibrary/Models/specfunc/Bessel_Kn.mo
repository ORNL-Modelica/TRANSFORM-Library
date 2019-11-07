within TRANSFORM.Math.GNU_ScientificLibrary.Models.specfunc;
model Bessel_Kn
  extends TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses.PartialBessel;

equation
  y = Functions.specfunc.bessel_Kn(n, x);
  annotation (Icon(graphics={Text(
          extent={{-70,22},{78,-16}},
          lineColor={0,0,0},
          textString="K(n,x)")}));
end Bessel_Kn;
