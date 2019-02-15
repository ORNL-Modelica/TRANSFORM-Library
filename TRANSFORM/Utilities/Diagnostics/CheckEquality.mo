within TRANSFORM.Utilities.Diagnostics;
block CheckEquality "Check equality between inputs up to a threshold"
  extends Modelica.Blocks.Icons.Block;
  parameter Real threshold(min=0) = 1e-2 "Threshold for equality comparison";
  Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y "Error"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = noEvent(if abs(u2-u1)<threshold  then 0 else u2-u1);
annotation (
defaultComponentName="check",
Documentation(info="<html>
<p>Block that outputs <i>0</i> if the difference <i>|u1-u2| &lt; threshold</i>, or else it outputs <i>u2-u1</i>. </p>
</html>",
revisions="<html>
</html>"),
    Icon(graphics={
        Text(
          extent={{-62,-38},{54,-68}},
          lineColor={0,0,255},
          textString="%threshold"),
               Text(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,0},
          textString="u1 = u2 ?")}));
end CheckEquality;
