within TRANSFORM.Utilities.Diagnostics;
block AssertInequality "Assert when condition is violated"
  extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threshold",
     threshold = 0);
equation
  if noEvent(time > t0) then
    assert(noEvent(u1 > u2 -threshold),  message + "\n"
      + "  time       = " + String(time) + "\n"
      + "  u1         = " + String(u1) + "\n"
      + "  u2         = " + String(u2) + "\n"
      + "  abs(u1-u2) = " + String(abs(u1-u2)) + "\n"
      + "  threshold  = " + String(threshold));
  end if;
annotation (
defaultComponentName="check",
Documentation(
info="<html>
<p>
Model that triggers an assert if
<i>u1 &gt; u2 - threShold</i>
and <i>t &gt; t<sub>0</sub></i>.
</p>
</html>",
revisions="<html>
</html>"),
    Icon(graphics={
               Text(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,0},
          textString="u1 > u2 ?")}));
end AssertInequality;
