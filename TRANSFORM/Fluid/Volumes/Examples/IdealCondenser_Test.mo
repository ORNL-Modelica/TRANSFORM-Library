within TRANSFORM.Fluid.Volumes.Examples;
model IdealCondenser_Test
  extends TRANSFORM.Icons.Example;
  Volumes.IdealCondenser condenser(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-26,16},{10,52}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    use_m_flow_in=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=10,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T sink(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=-10,
    T=323.15) annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={condenser.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  IdealCondenser         condenser1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p=100000,
    set_m_flow=true)
    annotation (Placement(transformation(extent={{-26,-64},{10,-28}})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    use_m_flow_in=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=10,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{-68,-30},{-48,-10}})));
  Modelica.Fluid.Sources.Boundary_pT      sink1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    T=323.15) annotation (Placement(transformation(extent={{40,-90},{20,-70}})));
equation
  connect(condenser.port_b, sink.ports[1]) annotation (Line(
      points={{-8,19.6},{-8,0},{20,0}},
      color={0,127,255}));
  connect(source.ports[1], condenser.port_a) annotation (Line(points={{-48,60},
          {-20.6,60},{-20.6,46.6}},    color={0,127,255}));
  connect(condenser1.port_b, sink1.ports[1]) annotation (Line(points={{-8,-60.4},
          {-8,-80},{20,-80}}, color={0,127,255}));
  connect(source1.ports[1], condenser1.port_a) annotation (Line(points={{-48,
          -20},{-20.6,-20},{-20.6,-33.4}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealCondenser_Test;
