within TRANSFORM.Math.Examples;
model check_linspace_2D

  extends TRANSFORM.Icons.Example;

  parameter Integer n1=5;
  parameter Integer n2=3;
  parameter Integer m=2;

  parameter Real x1=0;
  parameter Real x2=10;
  parameter Real x3=-5;
  parameter Real x4=5;

  Real y[n1,n2];
  Real y1[n1,n2];
  Real y2[n1,n2];
  Real y3[n1,n2,m];

  Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={y[3, 2],y1[3, 2],y2[3, 2],
        y3[3, 2, 2]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation

  y = linspace_2Dcorner(
    x1,
    x2,
    x3,
    x4,
    n1,
    n2);

  y1 = linspace_2Dedge(
    x1,
    x2,
    x3,
    x4,
    n1,
    n2);

  y2 = linspace_2Dedge(
    x1,
    x2,
    x3,
    x4,
    n1,
    n2,
    {true,false,false,true});

  y3 = linspaceRepeat_2Dedge(
    fill(x1, m),
    fill(x2, m),
    fill(x3, m),
    fill(x4, m),
    n1,
    n2);

  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_linspace_2D;
