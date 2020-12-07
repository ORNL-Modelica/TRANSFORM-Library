within TRANSFORM.Controls.Examples;
model LimPID_withReset_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine setPoi(f=1) "Set point signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  LimPID limPID_parameter(
    yMax=1,
    yMin=-1,
    y_reset=0.2,
    Ti=20,
    Td=10,
    k=0.2,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.3,
    reset=TRANSFORM.Types.Reset.Parameter,
    derMeas=false) "PID controller with integrator reset to a parameter value"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant mea(k=0.5) "Measured signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  LimPID limPID(
    initType=Modelica.Blocks.Types.Init.InitialState,
    Td=10,
    k=1,
    Ti=1,
    yMax=100,
    yMin=-100,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    xi_start=0.2,
    xd_start=0.1,
    derMeas=false) "PID controller without integrator reset"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.BooleanPulse trigger(
    width=50,
    startTime=0.1,
    period=0.2) "Boolean pulse to reset integrator"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  LimPID limPID_input(
    y_reset=0.2,
    Td=10,
    yMax=1,
    yMin=-1,
    k=0.2,
    Ti=20,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.3,
    reset=TRANSFORM.Types.Reset.Input,
    derMeas=false) "PID controller with integrator reset to an input value"
    annotation (Placement(transformation(extent={{20,-82},{40,-62}})));
  Modelica.Blocks.Sources.Constant conRes(k=0.9)
    "Signal to which integrator will be reset to"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Continuous.LimPID limPID_original(
    initType=Modelica.Blocks.Types.Init.InitialState,
    Td=10,
    k=1,
    Ti=1,
    yMax=100,
    yMin=-100,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    xi_start=0.2,
    xd_start=0.1) "PID controller from Modelica Standard Library"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Utilities.Diagnostics.AssertEquality       check
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Utilities.ErrorAnalysis.UnitTests           unitTests(n=4, x={
        limPID_original.y,limPID.y,limPID_parameter.y,limPID_input.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(setPoi.y, limPID_parameter.u_s)
    annotation (Line(points={{-19,-10},{0,-10},{18,-10}}, color={0,0,127}));
  connect(mea.y, limPID_parameter.u_m)
    annotation (Line(points={{-19,-40},{30,-40},{30,-22}}, color={0,0,127}));
  connect(setPoi.y, limPID.u_s) annotation (Line(points={{-19,-10},{-6,-10},{-6,
          30},{18,30}}, color={0,0,127}));
  connect(mea.y, limPID.u_m) annotation (Line(points={{-19,-40},{-12,-40},{-12,
          10},{30,10},{30,18}}, color={0,0,127}));
  connect(trigger.y, limPID_parameter.trigger) annotation (Line(points={{-19,20},
          {-10,20},{8,20},{8,-30},{22,-30},{22,-22}}, color={255,0,255}));
  connect(setPoi.y, limPID_input.u_s) annotation (Line(points={{-19,-10},{-6,
          -10},{-6,-72},{18,-72}}, color={0,0,127}));
  connect(mea.y, limPID_input.u_m) annotation (Line(points={{-19,-40},{-12,-40},
          {-12,-90},{30,-90},{30,-84}}, color={0,0,127}));
  connect(trigger.y, limPID_input.trigger) annotation (Line(points={{-19,20},{8,
          20},{8,-88},{22,-88},{22,-84}}, color={255,0,255}));
  connect(conRes.y, limPID_input.y_reset_in)
    annotation (Line(points={{-19,-80},{18,-80}}, color={0,0,127}));
  connect(setPoi.y, limPID_original.u_s) annotation (Line(points={{-19,-10},{-6,
          -10},{-6,70},{18,70}}, color={0,0,127}));
  connect(mea.y, limPID_original.u_m) annotation (Line(points={{-19,-40},{-12,-40},
          {-12,50},{30,50},{30,58}}, color={0,0,127}));
  connect(check.u1, limPID_original.y) annotation (Line(points={{58,56},{48,56},
          {48,70},{41,70}}, color={0,0,127}));
  connect(limPID.y, check.u2) annotation (Line(points={{41,30},{48,30},{48,44},
          {58,44}}, color={0,0,127}));
 annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/Continuous/Validation/LimPIDReset.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
</html>", info="<html>
<p>
This tests the LimPID with integrator reset enabled. Whenever the boolean pulse input becomes true,
the integrator is reset to <code>y_reset</code>.
</p>
</html>"));
end LimPID_withReset_Test;
