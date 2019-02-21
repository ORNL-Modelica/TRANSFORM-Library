within TRANSFORM.Math.Examples;
model check_fillArray
  extends TRANSFORM.Icons.Example;
  parameter Integer n=3;
  parameter Integer n2=2;
  parameter Integer n3=4;
  parameter Real val[4]={-1,2,3,10};
  Real y[n,size(val, 1)];
  Real y1[n,n2,size(val, 1)];
  Real y2[n,n2,n3,size(val, 1)];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={y[3, 2],y1[3, 2, 2],y2[3, 2, 2,4]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y = fillArray_1D(val, n);
  y1 = fillArray_2D(val, n, n2);
  y2 = fillArray_3D(val, n, n2, n3);
  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_fillArray;
