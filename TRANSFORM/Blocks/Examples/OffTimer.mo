within TRANSFORM.Blocks.Examples;
model OffTimer "Example model for off timer"
  extends TRANSFORM.Icons.Example;

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  TRANSFORM.Blocks.OffTimer offTim1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  TRANSFORM.Blocks.OffTimer offTim2
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={offTim1.y,offTim2.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(booleanPulse.y, offTim1.u) annotation (Line(
      points={{-59,10},{-2,10}},
      color={255,0,255}));
  connect(booleanPulse.y, not1.u) annotation (Line(
      points={{-59,10},{-50,10},{-50,-30},{-42,-30}},
      color={255,0,255}));
  connect(offTim2.u, not1.y) annotation (Line(
      points={{-2,-30},{-19,-30}},
      color={255,0,255}));
 annotation (
experiment(Tolerance=1e-6, StopTime=1),
    Documentation(
info="<html>
<p>The input to the two timers are alternating boolean values. Whenever the input becomes <span style=\"font-family: Courier New;\">false(=0)</span>, the timer is reset. The figures below show the input and output of the blocks.</p>
</html>",
revisions="<html>
</html>"));
end OffTimer;
