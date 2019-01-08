within TRANSFORM.Math.Examples;
model check_clamp

  extends TRANSFORM.Icons.Example;

  parameter Real min = -0.5;
  parameter Real max = 0.5;

  Real y;

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Modelica.Blocks.Sources.Sine x(freqHz=1/10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  y = clamp(x.y,min,max);

  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_clamp;
