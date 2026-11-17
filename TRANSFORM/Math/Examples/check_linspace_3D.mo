within TRANSFORM.Math.Examples;
model check_linspace_3D
  extends TRANSFORM.Icons.Example;
  parameter Integer n1=3;
  parameter Integer n2=3;
  parameter Integer n3=4;
  parameter Integer m=2;
  parameter Real x1=100;
  parameter Real x2=200;
  parameter Real x3=300;
  parameter Real x4=400;
  parameter Real x5=500;
  parameter Real x6=600;
  Real y[n1,n2,n3];
  Real y1[1,n2,n3];
  Real y2[n1,n2,n3,m];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={y[2,2,2],y[1,2,2],y1[1,2,2],
        y2[2,2,3,2]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y = linspace_3Dface(
    x1,
    x2,
    x3,
    x4,
    x5,
    x6,
    n1,
    n2,
    n3);
  y1 = linspace_3Dface(
    x1,
    x2,
    x3,
    x4,
    x5,
    x6,
    1,
    n2,
    n3);
  y2 = linspaceRepeat_3Dface(
    fill(x1, m),
    fill(x2, m),
    fill(x3, m),
    fill(x4, m),
    fill(x5, m),
    fill(x6, m),
    n1,
    n2,
    n3);
  annotation (experiment(StopTime=10), Documentation(info="<html>
<p>Checks <code>linspace_3Dface</code> and <code>linspaceRepeat_3Dface</code>: an element on a
face, an interior element, and an array with one element in dimension 1.</p>
</html>"));
end check_linspace_3D;
