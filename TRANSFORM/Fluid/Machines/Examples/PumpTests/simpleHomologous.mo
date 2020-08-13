within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model simpleHomologous
  "Basic model for testing the homologous pumps. Confirms nominal-in = nominal-out"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.He;
  TRANSFORM.Fluid.Machines.TurboPump_homologouscurves
                                     circulator(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="kPa") = 4800000,
    p_b_start(displayUnit="kPa") = 5000000,
    T_a_start=573.15,
    m_flow_start=3.2,
    N_nominal(displayUnit="rev/min") = 21000,
    m_flow_nominal=3.2,
    eta_nominal=1)
    annotation (Placement(transformation(extent={{10,20},{-10,40}})));
  Modelica.Mechanics.Rotational.Sources.Speed  speed  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{90,40},{70,20}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,40},{-70,20}})));
  Modelica.Blocks.Sources.RealExpression speedSource(y=circulator.omega_nominal)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,80})));
  TRANSFORM.Fluid.Volumes.MixingVolume supplyVolume(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 5000000,
    T_start=573.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,40},{-40,20}})));
  TRANSFORM.Fluid.Volumes.MixingVolume supplyVolume1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 4800000,
    T_start=573.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{40,40},{20,20}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(
      redeclare package Medium = Medium, R=circulator.dp_nominal/circulator.m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance1(
      redeclare package Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  TurboPump                          circulator1(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="kPa") = circulator.p_a_start,
    p_b_start(displayUnit="kPa") = circulator.p_b_start,
    T_a_start=circulator.T_a_start,
    m_flow_start=circulator.m_flow_start,
    N_nominal(displayUnit="rev/min") = circulator.N_nominal,
    m_flow_nominal=circulator.m_flow_nominal,
    eta_nominal=circulator.eta_nominal)
    annotation (Placement(transformation(extent={{10,-80},{-10,-60}})));
  Modelica.Mechanics.Rotational.Sources.Speed  speed1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
  BoundaryConditions.Boundary_pT                 source1(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{90,-60},{70,-80}})));
  BoundaryConditions.Boundary_pT                 sink1(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 4800000,
    T=573.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,-60},{-70,-80}})));
  Modelica.Blocks.Sources.RealExpression speedSource1(y=circulator1.omega_nominal)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,-20})));
  Volumes.MixingVolume                 supplyVolume2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 5000000,
    T_start=573.15,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,-60},{-40,-80}})));
  Volumes.MixingVolume                 supplyVolume3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start(displayUnit="MPa") = 4800000,
    T_start=573.15,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.001),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{40,-60},{20,-80}})));
  FittingsAndResistances.SpecifiedResistance                 resistance2(
      redeclare package Medium = Medium, R=circulator1.dp_nominal/circulator1.m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  FittingsAndResistances.SpecifiedResistance                 resistance3(
      redeclare package Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{60,-80},{40,-60}})));
equation
  connect(circulator.port_a, supplyVolume1.port_b[1])
    annotation (Line(points={{10,30},{24,30}},   color={0,127,255}));
  connect(supplyVolume.port_a[1], circulator.port_b)
    annotation (Line(points={{-24,30},{-10,30}},   color={0,127,255}));
  connect(supplyVolume.port_b[1], resistance.port_a)
    annotation (Line(points={{-36,30},{-43,30}},
                                               color={0,127,255}));
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{-57,30},{-70,30}},
                                               color={0,127,255}));
  connect(source.ports[1], resistance1.port_a)
    annotation (Line(points={{70,30},{57,30}},   color={0,127,255}));
  connect(resistance1.port_b, supplyVolume1.port_a[1])
    annotation (Line(points={{43,30},{36,30}},   color={0,127,255}));
  connect(speed.flange, circulator.shaft)
    annotation (Line(points={{0,40},{0,36}},color={0,0,0}));
  connect(speedSource.y, speed.w_ref) annotation (Line(points={{-8.88178e-16,69},
          {-8.88178e-16,62},{0,62}}, color={0,0,127}));
  connect(circulator1.port_a, supplyVolume3.port_b[1])
    annotation (Line(points={{10,-70},{24,-70}}, color={0,127,255}));
  connect(supplyVolume2.port_a[1], circulator1.port_b)
    annotation (Line(points={{-24,-70},{-10,-70}}, color={0,127,255}));
  connect(supplyVolume2.port_b[1], resistance2.port_a)
    annotation (Line(points={{-36,-70},{-43,-70}}, color={0,127,255}));
  connect(resistance2.port_b, sink1.ports[1])
    annotation (Line(points={{-57,-70},{-70,-70}}, color={0,127,255}));
  connect(source1.ports[1], resistance3.port_a)
    annotation (Line(points={{70,-70},{57,-70}}, color={0,127,255}));
  connect(resistance3.port_b,supplyVolume3. port_a[1])
    annotation (Line(points={{43,-70},{36,-70}}, color={0,127,255}));
  connect(speed1.flange, circulator1.shaft)
    annotation (Line(points={{0,-60},{0,-64}}, color={0,0,0}));
  connect(speedSource1.y, speed1.w_ref)
    annotation (Line(points={{0,-31},{0,-38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=2, __Dymola_Algorithm="Dassl"));
end simpleHomologous;
