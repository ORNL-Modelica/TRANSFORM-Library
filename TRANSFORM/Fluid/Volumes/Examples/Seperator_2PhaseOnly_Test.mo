within TRANSFORM.Fluid.Volumes.Examples;
model Seperator_2PhaseOnly_Test
  extends TRANSFORM.Icons.Example;
  Separator_2phaseOnly volume(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_a=1,
    nPorts_b=1,
    use_T_start=false,
    h_start=3e6)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.MassFlowSource_h source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=100,
    nPorts=1,
    h=2e6)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Boundary_ph sink(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    h=2e6) annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Modelica.Media.Water.StandardWater, R=1)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={volume.medium.h})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  BoundaryConditions.Boundary_ph sinkLiquid(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    h=1e5,
    nPorts=1,
    p=50000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
equation
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{37,0},{60,0}},   color={0,127,255}));
  connect(source.ports[1], volume.port_a[1])
    annotation (Line(points={{-60,0},{-6,0}}, color={0,127,255}));
  connect(resistance.port_a, volume.port_b[1])
    annotation (Line(points={{23,0},{6,0}}, color={0,127,255}));
  connect(volume.port_Liquid, sinkLiquid.ports[1])
    annotation (Line(points={{-4,-4},{-20,-4},{-20,20}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end Seperator_2PhaseOnly_Test;
