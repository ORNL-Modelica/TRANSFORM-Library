within TRANSFORM.Controls.Examples;
model LimPID_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  TRANSFORM.Controls.LimPID        limPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    derMeas=false)
          annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  TRANSFORM.Controls.LimPID limPID_reverse(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    derMeas=false,
    k=-1) "Controller with reverse action"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  TRANSFORM.Utilities.Diagnostics.AssertEquality assertEquality(
    threshold=1e-3)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Continuous.LimPID limPID_original(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  TRANSFORM.Utilities.Diagnostics.AssertEquality assertEquality1(
    threshold=1e-3)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={limPID_original.y,
        limPID.y,limPID_reverse.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(pulse.y, limPID.u_s) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127}));
  connect(pulse.y, limPID_reverse.u_s) annotation (Line(points={{-59,10},{-45.5,
          10},{-45.5,-40},{-22,-40}}, color={0,0,127}));
  connect(const.y, limPID.u_m) annotation (Line(
      points={{-59,-20},{-10,-20},{-10,-2}},
      color={0,0,127}));
  connect(const.y, limPID_reverse.u_m) annotation (Line(points={{-59,-20},{-52,-20},
          {-52,-60},{-10,-60},{-10,-52}}, color={0,0,127}));
  connect(limPID_reverse.y, gain.u)
    annotation (Line(points={{1,-40},{18,-40}}, color={0,0,127}));
  connect(gain.y, assertEquality.u2) annotation (Line(
      points={{41,-40},{50,-40},{50,-26},{58,-26}},
      color={0,0,127}));
  connect(limPID.y, assertEquality.u1) annotation (Line(
      points={{1,10},{30,10},{30,-14},{58,-14}},
      color={0,0,127}));
  connect(pulse.y, limPID_original.u_s) annotation (Line(points={{-59,10},{-45.5,
          10},{-45.5,50},{-22,50}}, color={0,0,127}));
  connect(const.y, limPID_original.u_m) annotation (Line(points={{-59,-20},{-52,
          -20},{-52,30},{-10,30},{-10,38}}, color={0,0,127}));
  connect(assertEquality1.u1, limPID_original.y) annotation (Line(points={{58,36},
          {30,36},{30,50},{1,50}}, color={0,0,127}));
  connect(assertEquality1.u2, limPID.y) annotation (Line(
      points={{58,24},{30,24},{30,10},{1,10}},
      color={0,0,127}));
 annotation (experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(revisions="<html>
</html>", info="<html>
<p>This model tests the implementation of the PID controller with optional reverse action.</p>
</html>"));
end LimPID_Test;
