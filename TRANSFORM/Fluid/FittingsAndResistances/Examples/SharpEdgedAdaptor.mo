within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model SharpEdgedAdaptor
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.FittingsAndResistances.SharpEdgedAdaptor from_dp(redeclare package Medium =
                       Modelica.Media.Air.DryAirNasa, dimensions_ab={
        dimension_a.y,0.01})
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Fluid.Sources.FixedBoundary OUT_dp(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,20})));
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-40})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-40})));
  Modelica.Fluid.Sources.Boundary_pT IN_p(
    nPorts=1,
    T(displayUnit="K") = system.T_ambient,
    p(displayUnit="Pa") = system.p_ambient,
    use_p_in=true,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.RealExpression input_p(y=from_mflow.port_a.p)
    annotation (Placement(transformation(extent={{-100,
            10},{-80,30}})));
  Modelica.Blocks.Sources.Sine input_mflow(
    f=1,
    offset=0,
    amplitude=0.001) annotation (Placement(transformation(extent={{-100,
            -50},{-80,-30}})));
  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=0.01) annotation (Placement(transformation(extent={{80, -100}, {100, -80}})));
  TRANSFORM.Fluid.FittingsAndResistances.SharpEdgedAdaptor from_mflow(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa, dimensions_ab={
        dimension_a.y,0.01})
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Ramp dimension_a(
    offset=0.005,
    startTime=0,
    height=0.01,
    duration=0.5)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(IN_p.ports[1], from_dp.port_a)
    annotation (Line(points={{-40,20},{-26,20},{-10,20}}, color={0,127,255}));
  connect(IN_mflow.ports[1], from_mflow.port_a) annotation (Line(points={{-40,
          -40},{-25,-40},{-10,-40}}, color={0,127,255}));
  connect(from_mflow.port_b, OUT_mflow.ports[1])
    annotation (Line(points={{10,-40},{25,-40},{40,-40}}, color={0,127,255}));
  connect(input_mflow.y, IN_mflow.m_flow_in) annotation (Line(points={{-79,-40},
          {-70,-40},{-70,-32},{-60,-32}}, color={0,0,127}));
  connect(input_p.y, IN_p.p_in) annotation (Line(points={{-79,20},{-70,20},{-70,
          28},{-62,28}}, color={0,0,127}));
  connect(from_dp.port_b, OUT_dp.ports[1])
    annotation (Line(points={{10,20},{25,20},{40,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Interval=0.0002));
end SharpEdgedAdaptor;
