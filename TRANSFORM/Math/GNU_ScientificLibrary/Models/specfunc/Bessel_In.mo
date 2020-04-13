within TRANSFORM.Math.GNU_ScientificLibrary.Models.specfunc;
model Bessel_In
  extends TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses.PartialBessel;

equation
  y = Functions.specfunc.bessel_In(n, x);
  annotation (Icon(graphics={Text(
          extent={{-74,24},{82,-12}},
          lineColor={0,0,0},
          textString="I(n,x)")}));
end Bessel_In;
