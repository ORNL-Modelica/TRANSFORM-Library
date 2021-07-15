within TRANSFORM.Controls.Examples.FeedForward;
model getRPM_centrifugalPump_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
    package Medium = Modelica.Media.Water.StandardWater;
  Modelica.Fluid.Sources.Boundary_pT                       pressureBoundary_h(
    use_p_in=true,
    T=293.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Fluid.Sources.Boundary_ph                       pressureBoundary_h1(
    p=500000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=min(20000, 1200 +
        time)) annotation (Placement(transformation(extent={{-28,12},{-8,32}})));
  Modelica.Blocks.Sources.Constant const(k=2e5)
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1,
    offset=0,
    amplitude=0.1e5)
    annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-62,28},{-42,48}})));
  TRANSFORM.Controls.FeedForward.getRPM_centrifugalPump centrifugalPumpInverse(
    dp=pump.dp,
    omega_RPM_nom=pump.N_nominal,
    m_flow_ref=pump.m_flow,
    q_nom=(pump.m_flow_nominal/pump.d_nominal)*{0,1,2},
    head_nom=(1/10*1/pump.d_nominal)*(6.9e5 - 1.95e5)*{2,1,0},
    d_inlet=Medium.density(pump.medium.state))
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Utilities.Visualizers.displayReal actual(
    use_port=false,
    precision=2,
    val=pump.N)
    annotation (Placement(transformation(extent={{60,-62},{80,-42}})));
  Utilities.Visualizers.displayReal predicted(
    use_port=false,
    val=centrifugalPumpInverse.y,
    precision=2)
    annotation (Placement(transformation(extent={{60,-86},{80,-66}})));
  Fluid.Machines.Pump pump(
    exposeState_a=false,
    m_flow_nominal=0.78*3*(230 - 200),
    N_nominal=1200,
    dp_nominal=6.9e5 - 1.95e5,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(1.95e5)),
    redeclare model FlowChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PerformanceCurve
        (V_flow_curve=(pump.m_flow_nominal/pump.d_nominal)*{0,1,2}, head_curve=
            (1/10*1/pump.d_nominal)*(6.9e5 - 1.95e5)*{2,1,0}),
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant
        (eta_constant=0.8),
    V=0.1,
    N_input=realExpression.y,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_a_start=600000,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={actual.val,
        predicted.val})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(sine.y, add.u1)
    annotation (Line(points={{-71,50},{-64,50},{-64,44}}, color={0,0,127}));
  connect(const.y, add.u2)
    annotation (Line(points={{-71,20},{-64,20},{-64,32}}, color={0,0,127}));
  connect(add.y, pressureBoundary_h.p_in) annotation (Line(points={{-41,38},{
          -40,38},{-40,20},{-62,20},{-62,8}},   color={0,0,127}));
  connect(pump.port_a, pressureBoundary_h.ports[1])
    annotation (Line(points={{-10,0},{-26,0},{-40,0}}, color={0,127,255}));
  connect(pump.port_b, pressureBoundary_h1.ports[1])
    annotation (Line(points={{10,0},{25,0},{40,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
                                      Text(
          extent={{56,-40},{86,-46}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid,
          textString="Pump reference"),
                                      Text(
          extent={{56,-66},{84,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid,
          textString="Pump predicted")}));
end getRPM_centrifugalPump_Test;
