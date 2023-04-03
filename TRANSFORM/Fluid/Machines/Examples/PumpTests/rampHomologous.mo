within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model rampHomologous
  "Compare results of different pumps using same boundary conditions"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.He;
  TRANSFORM.Fluid.Machines.TurboPump_homologouscurves
                                     circulator(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="kPa") = 4800000,
    p_b_start(displayUnit="kPa") = 5000000,
    T_a_start=573.15,
    m_flow_start=3.2,
    omega_nominal(displayUnit="rpm") = 2199.1148575129,
    m_flow_nominal=3.2,
    eta_nominal=1)
    annotation (Placement(transformation(extent={{10,90},{-10,70}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{90,70},{70,90}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  TRANSFORM.Fluid.Volumes.MixingVolume supplyVolume(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 5000000,
    T_start=573.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (
         V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  TRANSFORM.Fluid.Volumes.MixingVolume supplyVolume1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 4800000,
    T_start=573.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (
         V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{40,70},{20,90}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(
      redeclare package Medium = Medium, R=circulator.dp_nominal/circulator.m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,90},{-60,70}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance1(
      redeclare package Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{60,90},{40,70}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,44})));
  TurboPump                          circulator1(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="kPa") = circulator.p_a_start,
    p_b_start(displayUnit="kPa") = circulator.p_b_start,
    T_a_start=circulator.T_a_start,
    m_flow_start=circulator.m_flow_start,
    omega_nominal=circulator.omega_nominal,
    m_flow_nominal=circulator.m_flow_nominal,
    eta_nominal=circulator.eta_nominal)
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));
  BoundaryConditions.Boundary_pT                 source1(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{90,-70},{70,-90}})));
  BoundaryConditions.Boundary_pT                 sink1(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-90}})));
  Volumes.MixingVolume                 supplyVolume2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 5000000,
    T_start=573.15,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,-70},{-40,-90}})));
  Volumes.MixingVolume                 supplyVolume3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 4800000,
    T_start=573.15,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{40,-70},{20,-90}})));
  FittingsAndResistances.SpecifiedResistance                 resistance2(
      redeclare package Medium = Medium, R=circulator1.dp_nominal/circulator1.m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-90},{-60,-70}})));
  FittingsAndResistances.SpecifiedResistance                 resistance3(
      redeclare package Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{60,-90},{40,-70}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-44})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    J=0.1,
    w(start=circulator.omega_nominal),
    a(start=0)) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,64})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(
    J=inertia.J,
    w(start=circulator1.omega_nominal),
    a(start=0)) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,-64})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=-circulator.tau_nominal,
    rising=2,
    width=5,
    falling=2,
    period=20,
    offset=circulator.tau_nominal,
    startTime=10)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
equation
  connect(circulator.port_a, supplyVolume1.port_b[1])
    annotation (Line(points={{10,80},{24,80}},   color={0,127,255}));
  connect(supplyVolume.port_a[1], circulator.port_b)
    annotation (Line(points={{-24,80},{-10,80}},   color={0,127,255}));
  connect(supplyVolume.port_b[1], resistance.port_a)
    annotation (Line(points={{-36,80},{-43,80}},
                                               color={0,127,255}));
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{-57,80},{-70,80}},
                                               color={0,127,255}));
  connect(source.ports[1], resistance1.port_a)
    annotation (Line(points={{70,80},{57,80}},   color={0,127,255}));
  connect(resistance1.port_b, supplyVolume1.port_a[1])
    annotation (Line(points={{43,80},{36,80}},   color={0,127,255}));
  connect(circulator1.port_a,supplyVolume3. port_b[1])
    annotation (Line(points={{10,-80},{24,-80}}, color={0,127,255}));
  connect(supplyVolume2.port_a[1],circulator1. port_b)
    annotation (Line(points={{-24,-80},{-10,-80}}, color={0,127,255}));
  connect(supplyVolume2.port_b[1],resistance2. port_a)
    annotation (Line(points={{-36,-80},{-43,-80}}, color={0,127,255}));
  connect(resistance2.port_b,sink1. ports[1])
    annotation (Line(points={{-57,-80},{-70,-80}}, color={0,127,255}));
  connect(source1.ports[1],resistance3. port_a)
    annotation (Line(points={{70,-80},{57,-80}}, color={0,127,255}));
  connect(resistance3.port_b,supplyVolume3. port_a[1])
    annotation (Line(points={{43,-80},{36,-80}}, color={0,127,255}));
  connect(torque1.flange, inertia1.flange_a)
    annotation (Line(points={{-1.77636e-15,-54},{0,-54}}, color={0,0,0}));
  connect(circulator1.shaft, inertia1.flange_b)
    annotation (Line(points={{0,-74},{0,-74}}, color={0,0,0}));
  connect(circulator.shaft, inertia.flange_b)
    annotation (Line(points={{0,74},{4.44089e-16,74}}, color={0,0,0}));
  connect(torque.flange, inertia.flange_a)
    annotation (Line(points={{0,54},{-4.44089e-16,54}}, color={0,0,0}));
  connect(torque.tau, torque1.tau) annotation (Line(points={{0,32},{0,0},{
          2.22045e-15,0},{2.22045e-15,-32}}, color={0,0,127}));
  connect(trapezoid.y, torque1.tau) annotation (Line(points={{-71,0},{
          2.22045e-15,0},{2.22045e-15,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=200,
      __Dymola_Algorithm="Dassl"));
end rampHomologous;
