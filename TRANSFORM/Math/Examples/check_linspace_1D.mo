within TRANSFORM.Math.Examples;
model check_linspace_1D
  extends TRANSFORM.Icons.Example;
  parameter Integer n=5;
  parameter Integer m=2;
  parameter Integer p=3;
  parameter Real x1=0;
  parameter Real x2=10;
  Real y[n];
  Real y1[m,n];
  Real y2[p,m,n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={y[3],y1[2, 4],y2[2, 1, 2]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y = linspace_1D(
    0,
    10,
    n);
  y1 = linspaceRepeat_1D(
    y,
    y,
    m);
  y2 = linspaceRepeat_1D_multi(
    y1,
    y1,
    p);
  annotation (experiment(StopTime=10));
end check_linspace_1D;
