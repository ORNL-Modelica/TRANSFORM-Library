within TRANSFORM.Blocks.Examples;
model Latch_Test
  extends TRANSFORM.Icons.Example;

  Logical.Latch latch
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    width=50,
    period=0.2,
    startTime=0.1)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={latch.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(booleanPulse.y, latch.trigger) annotation (Line(points={{-39,20},{-16,
          20},{-16,6},{-12,6}}, color={255,0,255}));
  connect(ramp.y, latch.u) annotation (Line(points={{-39,-10},{-26,-10},{-26,0},
          {-12,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100, __Dymola_Algorithm="Dassl"));
end Latch_Test;
