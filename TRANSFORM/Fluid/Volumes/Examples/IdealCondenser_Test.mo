within TRANSFORM.Fluid.Volumes.Examples;
model IdealCondenser_Test
  extends Modelica.Icons.Example;
  Volumes.IdealCondenser condenser(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-28,-20},{32,40}})));
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
    T=323.15) annotation (Placement(transformation(extent={{72,-50},{52,-30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={condenser.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(condenser.port_b, sink.ports[1]) annotation (Line(
      points={{2,-20},{0,-20},{0,-40},{52,-40}},
      color={0,127,255}));
  connect(source.ports[1], condenser.port_a) annotation (Line(points={{-48,60},
          {-36,60},{-19,60},{-19,40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealCondenser_Test;
