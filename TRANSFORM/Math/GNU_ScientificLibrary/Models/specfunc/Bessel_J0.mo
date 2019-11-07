within TRANSFORM.Math.GNU_ScientificLibrary.Models.specfunc;
model Bessel_J0
  extends TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses.PartialBessel(
      final n=0);

equation
  y = Functions.specfunc.bessel_J0(x);
  annotation (Icon(graphics={Text(
          extent={{-78,18},{70,-12}},
          lineColor={0,0,0},
          textString="J(0,x)")}));
end Bessel_J0;
