within TRANSFORM.Math.Examples;
model check_regExponent "Test problem for cubic hermite splines"
  extends TRANSFORM.Icons.Example;
  parameter Real deltax=1;
  parameter Real z = 1;
  Real y_act=x.y^z;
  Real y;
  Real dy;
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={y,dy})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Trapezoid x(
    amplitude=2,
    rising=0.5,
    width=0,
    falling=0.5,
    period=1) annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

equation
  y = regExponent_cinterp(x=x.y, deltax=deltax,z=z);
  dy = der(y);

  annotation (experiment(StopTime=2), Documentation(info="<html>
<p>This example demonstrates the use of the function for cubic hermite interpolation and linear extrapolation. The example use interpolation with two different settings: One settings produces a monotone cubic hermite, whereas the other setting does not enforce monotonicity.</p>
<p><br><span style=\"font-family: Courier New;\">Adapted&nbsp;from&nbsp;Buildings&nbsp;Library</span></p>
</html>"));
end check_regExponent;
