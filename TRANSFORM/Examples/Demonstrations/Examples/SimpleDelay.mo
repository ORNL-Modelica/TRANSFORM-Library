within TRANSFORM.Examples.Demonstrations.Examples;
model SimpleDelay

  extends Icons.Example;

  parameter Real tau = 0.01;

  Real y_delay;

  Modelica.Blocks.Sources.Sine sine(freqHz=1/10, startTime=10)
    annotation (Placement(transformation(extent={{-62,4},{-42,24}})));

equation

  der(y_delay) = (sine.y-y_delay)/tau;

  annotation (                                 experiment(StopTime=100));
end SimpleDelay;
