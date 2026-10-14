within TRANSFORM.Fluid.Volumes.Examples;
model SimpleVolume_Test
  extends TRANSFORM.Icons.Example;
  SimpleVolume volume(redeclare package Medium =
        Modelica.Media.Water.StandardWater, redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  BoundaryConditions.MassFlowSource_h source(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=1e5,
    m_flow=100)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  BoundaryConditions.Boundary_ph sink(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    h=1e5) annotation (Placement(transformation(extent={{80,10},{60,30}})));
  FittingsAndResistances.SpecifiedResistance resistance(redeclare package Medium =
               Modelica.Media.Water.StandardWater, R=1)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  SimpleVolume volume1(redeclare package Medium =
        Modelica.Media.Water.StandardWater, redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1))
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  BoundaryConditions.Boundary_ph source1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=3e5,
    use_p_in=true,
    p=100000)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  BoundaryConditions.Boundary_ph sink1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    h=1e5) annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
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
equation
  connect(source.ports[1], volume.port_a)
    annotation (Line(points={{-60,20},{-6,20}}, color={0,127,255}));
  connect(volume.port_b, resistance.port_a)
    annotation (Line(points={{6,20},{23,20}}, color={0,127,255}));
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{37,20},{60,20}}, color={0,127,255}));
  connect(volume1.port_b, resistance1.port_a)
    annotation (Line(points={{6,-20},{13,-20}}, color={0,127,255}));
  connect(resistance1.port_b, sink1.ports[1])
    annotation (Line(points={{27,-20},{40,-20}}, color={0,127,255}));
  connect(source1.ports[1], resistance2.port_a)
    annotation (Line(points={{-40,-20},{-27,-20}}, color={0,127,255}));
  connect(resistance2.port_b, volume1.port_a)
    annotation (Line(points={{-13,-20},{-6,-20}}, color={0,127,255}));
  connect(sine.y, source1.p_in)
    annotation (Line(points={{-69,-12},{-62,-12}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100),
    Documentation(info="<html>
<p>Demonstrates two independent uses of <code>TRANSFORM.Fluid.Volumes.SimpleVolume</code> with StandardWater. The upper circuit uses a mass-flow source, a volume, a specified resistance, and a pressure boundary. The lower circuit drives a pressure boundary with a sine signal before another resistance and volume.</p>
<p>Simulate to <code>100 s</code> and inspect <code>volume.medium.h</code> and <code>volume1.medium.h</code>. The <code>unitTests</code> component identifies those two specific-enthalpy signals for regression comparison; this example does not by itself establish physical or cross-tool validation.</p>
</html>"));
end SimpleVolume_Test;
