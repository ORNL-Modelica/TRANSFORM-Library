within TRANSFORM.Math.Examples;
model check_mean

  extends TRANSFORM.Icons.Example;

  parameter Real x[11] = linspace(0,10,11);
  Real y;

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation
  y = mean(x);

  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_mean;
