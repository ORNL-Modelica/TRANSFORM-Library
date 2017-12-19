within TRANSFORM.Fluid.Volumes.Examples;
model ExpansionTank2_Test

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater(extraPropertiesNames={"CO2"}, C_nominal={1.519E-1});

  ExpansionTank_1Port
                expansionTank(
    A=1,
    allowFlowReversal=true,
    level_start=0.5,
    redeclare package Medium = Medium,
    p_surface=80000,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  BoundaryConditions.MassFlowSource_T boundary(
    m_flow=1,
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_C_in=true,
    T=293.15,
    nPorts=1)
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
  MixingVolume volume(
    nPorts_a=1,
    nPorts_b=2,
    redeclare package Medium = Medium,
    p_start=100000,
    T_start=293.15,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.001))
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  FittingsAndResistances.SpecifiedResistance resistance1(
                                                        R=0.01, redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,12})));
equation
  connect(resistance.port_b, boundary1.ports[1])
    annotation (Line(points={{37,0},{60,0}}, color={0,127,255}));
  connect(ramp.y, boundary.m_flow_in)
    annotation (Line(points={{-59,8},{-40,8}}, color={0,0,127}));
  connect(ramp1.y, boundary.C_in[1]) annotation (Line(points={{-59,-32},{-50,
          -32},{-50,-8},{-40,-8}}, color={0,0,127}));
  connect(boundary.ports[1], volume.port_a[1])
    annotation (Line(points={{-20,0},{-12,0}}, color={0,127,255}));
  connect(volume.port_b[1], resistance.port_a) annotation (Line(points={{0,-0.5},
          {12,-0.5},{12,0},{23,0}}, color={0,127,255}));
  connect(resistance1.port_a, volume.port_b[2])
    annotation (Line(points={{10,5},{10,0.5},{0,0.5}}, color={0,127,255}));
  connect(resistance1.port_b, expansionTank.port)
    annotation (Line(points={{10,19},{10,31.6}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end ExpansionTank2_Test;
