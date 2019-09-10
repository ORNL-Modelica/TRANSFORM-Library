within TRANSFORM.Math.Examples;
model check_regFun3 "Test problem for cubic hermite splines"
  extends TRANSFORM.Icons.Example;
  parameter Real[:] xd={-1,1,5,6} "Support points";
  parameter Real[size(xd, 1)] yd={-1,1,2,10} "Support points";
  parameter Real[size(xd, 1)] d(each fixed=false)
    "Derivatives at the support points";
  Real x "Independent variable";
  Real y "Dependent variable";
  Integer i "Integer to select data interval";
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
initial algorithm
  // Get the derivative values at the support points
  d := splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=false);
algorithm
  x := xd[1] + time*1.2*(xd[size(xd, 1)] - xd[1]) - 0.5;
  // i is a counter that is used to pick the derivative of d or dMonotonic
  // that correspond to the interval that contains x
  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if x > xd[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  y := regFun3(
    x=x,
    x1=xd[i],
    x2=xd[i + 1],
    y1=yd[i],
    y2=yd[i + 1],
    y1d=d[i],
    y2d=d[i + 1]);
  annotation (experiment(StopTime=1.0), Documentation(info="<html>
<p>This example demonstrates the use of the function for cubic hermite interpolation and linear extrapolation. The example use interpolation with two different settings: One settings produces a monotone cubic hermite, whereas the other setting does not enforce monotonicity.</p>
<p><br><span style=\"font-family: Courier New;\">Adapted&nbsp;from&nbsp;Buildings&nbsp;Library</span></p>
</html>"));
end check_regFun3;
