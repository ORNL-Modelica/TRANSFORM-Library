within TRANSFORM.Blocks.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Constant cons(k=10) "Constant as source term"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  TRANSFORM.Blocks.IntegratorWithReset intWitRes1(
    y_start=5, reset=TRANSFORM.Types.Reset.Parameter,
    k=0.5,
    y_reset=2)                                      "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  TRANSFORM.Blocks.IntegratorWithReset intWitRes2(
    y_reset=10,
    y_start=-5,
    reset=TRANSFORM.Types.Reset.Input,
    k=0.5)     "Integrator with reset and y_reset = 2"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  TRANSFORM.Blocks.IntegratorWithReset intNoReset(
    reset=TRANSFORM.Types.Reset.Disabled,
    k=0.5,
    y_start=1)
    "Integrator without reset"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.2)
    "Sample trigger"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=1,
    offset=-2) "Ramp as a source term"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  TRANSFORM.Blocks.IntegratorWithReset intDef
    "Integrator with default values"
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={intWitRes1.y,intWitRes2.y,
        intDef.y,intNoReset.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(cons.y, intWitRes1.u) annotation (Line(points={{-39,70},{-26,70},{-26,
          30},{-12,30}}, color={0,0,127}));
  connect(intNoReset.u, cons.y) annotation (Line(points={{-12,70},{-12,70},{-28,
          70},{-39,70}}, color={0,0,127}));
  connect(cons.y, intWitRes2.u) annotation (Line(points={{-39,70},{-39,70},{-26,
          70},{-26,-20},{-12,-20}}, color={0,0,127}));
  connect(sampleTrigger.y, intWitRes1.trigger) annotation (Line(points={{-39,10},
          {0,10},{0,18}},             color={255,0,255}));
  connect(booleanPulse.y, intWitRes2.trigger)
    annotation (Line(points={{-39,-60},{0,-60},{0,-32}},   color={255,0,255}));
  connect(ramp.y, intWitRes2.y_reset_in) annotation (Line(points={{-39,-20},{
          -39,-20},{-34,-20},{-34,-28},{-12,-28}},
                                     color={0,0,127}));
  connect(cons.y, intDef.u) annotation (Line(points={{-39,70},{-26,70},{-26,-80},
          {-14,-80}}, color={0,0,127}));
annotation (experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>This model tests with and without reset, and with different start values and reset values. </p>
<p>The integrator <span style=\"font-family: Courier New;\">intWitRes1</span> is triggered by a sample trigger which becomes true at <i>t=0</i>, while <span style=\"font-family: Courier New;\">intWitRes2</span> is triggered by a boolean pulse with is true at <i>t=0</i>. Hence, <span style=\"font-family: Courier New;\">intWitRes1</span> starts with <span style=\"font-family: Courier New;\">y(0)=y_reset</span> while <span style=\"font-family: Courier New;\">intWitRes2</span> starts with <span style=\"font-family: Courier New;\">y(0)=y_start</span>. </p>
</html>", revisions="<html>
</html>"));
end IntegratorWithReset;
