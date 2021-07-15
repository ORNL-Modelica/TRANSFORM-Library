within TRANSFORM.Blocks.Examples;
model SwitchHold_Test
  extends TRANSFORM.Icons.Example;

  Utilities.ErrorAnalysis.UnitTests unitTests(x={switch.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Logical.SwitchHold switch
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine sine(f=1)
    annotation (Placement(transformation(extent={{-32,22},{-12,42}})));
  Modelica.Blocks.Sources.Ramp ramp(height=10, duration=1)
    annotation (Placement(transformation(extent={{-32,-38},{-12,-18}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    width=33,
    period=1,
    startTime=0.2)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
equation
  connect(ramp.y, switch.u3) annotation (Line(points={{-11,-28},{4,-28},{4,-8},
          {18,-8}}, color={0,0,127}));
  connect(sine.y, switch.u1)
    annotation (Line(points={{-11,32},{4,32},{4,8},{18,8}}, color={0,0,127}));
  connect(booleanPulse.y, switch.u2)
    annotation (Line(points={{-31,0},{18,0}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100, __Dymola_Algorithm="Dassl"));
end SwitchHold_Test;
