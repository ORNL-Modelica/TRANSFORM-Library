within TRANSFORM.Math.Examples;
model check_cumulativeSum
  extends TRANSFORM.Icons.Example;
  parameter Real u[11] = linspace(0,10,11);
  Real y[size(u, 1)];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=11,x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y = cumulativeSum(u);
  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_cumulativeSum;
