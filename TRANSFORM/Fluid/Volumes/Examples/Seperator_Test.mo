within TRANSFORM.Fluid.Volumes.Examples;
model Seperator_Test
  extends TRANSFORM.Icons.Example;
  Separator volume(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  BoundaryConditions.MassFlowSource_h source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=100,
    nPorts=1,
    h=2e6)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  BoundaryConditions.Boundary_ph sink(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    h=1e5) annotation (Placement(transformation(extent={{80,10},{60,30}})));
  FittingsAndResistances.SpecifiedResistance resistance(redeclare package Medium =
               Modelica.Media.Water.StandardWater, R=1)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Separator volume1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_a=2,
    nPorts_b=2)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  BoundaryConditions.Boundary_ph source1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=true,
    p=100000,
    h=2e6)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  BoundaryConditions.Boundary_ph sink1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=1e5,
    p=100000)
           annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  FittingsAndResistances.SpecifiedResistance resistance1(redeclare package Medium =
               Modelica.Media.Water.StandardWater, R=1)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  FittingsAndResistances.SpecifiedResistance resistance2(redeclare package Medium =
               Modelica.Media.Water.StandardWater, R=1)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/10,
    startTime=1,
    offset=1e5,
    amplitude=0.5e4)
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={volume.medium.h,volume1.medium.h})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  BoundaryConditions.MassFlowSource_h source1b(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=1e5,
    m_flow=100,
    nPorts=1) annotation (Placement(transformation(extent={{-40,-18},{-20,2}})));
  BoundaryConditions.MassFlowSource_h sink1b(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=100,
    nPorts=1,
    use_m_flow_in=true,
    h=2e6) annotation (Placement(transformation(extent={{40,-18},{20,2}})));
  Modelica.Blocks.Sources.Sine sine1(
    f=1/10,
    startTime=1,
    amplitude=200,
    offset=100)
    annotation (Placement(transformation(extent={{90,-20},{70,0}})));
  BoundaryConditions.Boundary_ph sinkLiquid1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    h=1e5,
    nPorts=1,
    p=50000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-4,-70})));
  BoundaryConditions.Boundary_ph sinkLiquid(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    h=1e5,
    nPorts=1,
    p=50000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,50})));
equation
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{37,20},{60,20}}, color={0,127,255}));
  connect(resistance1.port_b, sink1.ports[1])
    annotation (Line(points={{27,-20},{40,-20}}, color={0,127,255}));
  connect(source1.ports[1], resistance2.port_a)
    annotation (Line(points={{-40,-20},{-27,-20}}, color={0,127,255}));
  connect(sine.y, source1.p_in)
    annotation (Line(points={{-69,-12},{-62,-12}}, color={0,0,127}));
  connect(source.ports[1], volume.port_a[1])
    annotation (Line(points={{-60,20},{-6,20}}, color={0,127,255}));
  connect(resistance.port_a, volume.port_b[1])
    annotation (Line(points={{23,20},{6,20}}, color={0,127,255}));
  connect(resistance2.port_b, volume1.port_a[1]) annotation (Line(points={{-13,
          -20},{-10,-20},{-10,-20.5},{-6,-20.5}}, color={0,127,255}));
  connect(volume1.port_b[1], resistance1.port_a) annotation (Line(points={{6,
          -20.5},{10,-20.5},{10,-20},{13,-20}}, color={0,127,255}));
  connect(source1b.ports[1], volume1.port_a[2]) annotation (Line(points={{-20,
          -8},{-10,-8},{-10,-19.5},{-6,-19.5}}, color={0,127,255}));
  connect(sink1b.ports[1], volume1.port_b[2]) annotation (Line(points={{20,-8},
          {10,-8},{10,-19.5},{6,-19.5}}, color={0,127,255}));
  connect(sine1.y, sink1b.m_flow_in) annotation (Line(points={{69,-10},{60,-10},
          {60,0},{40,0}}, color={0,0,127}));
  connect(volume.port_Liquid, sinkLiquid.ports[1])
    annotation (Line(points={{-4,16},{-20,16},{-20,40}}, color={0,127,255}));
  connect(volume1.port_Liquid, sinkLiquid1.ports[1])
    annotation (Line(points={{-4,-24},{-4,-60}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end Seperator_Test;
