within TRANSFORM.Fluid.Volumes.Examples;
model ExpansionTank_Test

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames={
          "CO2"}, C_nominal={1.519E-1});

  ExpansionTank expansionTank(
    A=1,
    allowFlowReversal=true,
    level_start=0.5,
    redeclare package Medium = Medium,
    p_surface=80000,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,12},{10,32}})));
  BoundaryConditions.MassFlowSource_T boundary(
    nPorts=1,
    m_flow=1,
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_C_in=true,
    T=293.15)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  FittingsAndResistances.SpecifiedResistance resistance(R=0.01, redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  BoundaryConditions.Boundary_pT boundary1(
    nPorts=1,
    p=100000,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    startTime=20,
    height=1,
    offset=0) annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    height=1,
    offset=0,
    startTime=40)
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={expansionTank.C[1],
        expansionTank.level})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundary.ports[1], expansionTank.port_a)
    annotation (Line(points={{-20,0},{-6,0},{-6,16}}, color={0,127,255}));
  connect(resistance.port_a, expansionTank.port_b)
    annotation (Line(points={{23,0},{6,0},{6,16}}, color={0,127,255}));
  connect(resistance.port_b, boundary1.ports[1])
    annotation (Line(points={{37,0},{60,0}}, color={0,127,255}));
  connect(ramp.y, boundary.m_flow_in)
    annotation (Line(points={{-59,8},{-40,8}}, color={0,0,127}));
  connect(ramp1.y, boundary.C_in[1]) annotation (Line(points={{-59,-32},{-50,
          -32},{-50,-8},{-40,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end ExpansionTank_Test;
