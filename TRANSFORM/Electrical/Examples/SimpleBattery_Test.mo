within TRANSFORM.Electrical.Examples;
model SimpleBattery_Test
  extends TRANSFORM.Icons.Example;

  Batteries.SimpleBattery battery(capacity_max=1e5)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Sources.FrequencySource boundary
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=1e6,
    rising=1000,
    width=1000,
    falling=1000,
    period=4000,
    offset=-5e5,
    startTime=1000)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={battery.E})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(battery.port, boundary.port)
    annotation (Line(points={{12,0},{40,0}}, color={255,0,0}));
  connect(trapezoid.y, battery.W_setpoint)
    annotation (Line(points={{-37,0},{-8.8,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10000,
      __Dymola_Algorithm="Dassl"));
end SimpleBattery_Test;
