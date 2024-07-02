within TRANSFORM.Examples.Demonstrations.Examples;
model SimpleDelay

  extends Icons.Example;

  parameter Real tau = 0.01;

  Real y_delay;
  Real y_delay_func;

  Real y_int, y_int2;
  Real y_delay_int, y_delay_int2;

  Modelica.Blocks.Sources.Sine sine(f=1/10, startTime=10)
    annotation (Placement(transformation(extent={{-62,4},{-42,24}})));

equation

  der(y_delay) = (sine.y-y_delay)/tau;
  y_delay_func = delay(sine.y, tau);


  der(y_int) = (sine.y-y_int)/(tau/100);
  y_delay_int = delay(y_int, tau);

  y_int2 = delay(sine.y, tau);
  der(y_delay_int2) = (y_int2-y_delay_int2)/(tau/100);

  annotation (                                 experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end SimpleDelay;
