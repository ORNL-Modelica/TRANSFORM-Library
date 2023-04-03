within TRANSFORM.Fluid.Volumes.Examples;
model DumpTank_Test
   replaceable package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames={"CO2"},
         C_nominal={1.519E-1});
  extends TRANSFORM.Icons.Example;
  BoundaryConditions.MassFlowSource_h source(
    h=1e5,
    m_flow=100,
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  BoundaryConditions.Boundary_ph sink(
    nPorts=1,
    p=100000,
    h=1e5,
    redeclare package Medium = Medium)
           annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  FittingsAndResistances.SpecifiedResistance resistance(
                                                   R=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  DumpTank dumpTank(
    A=1,
    redeclare package Medium = Medium,
    level_start=1)
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={dumpTank.level})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{27,-20},{50,-20}},
                                               color={0,127,255}));
  connect(source.ports[1], dumpTank.port_a)
    annotation (Line(points={{-40,20},{0,20},{0,14.4}}, color={0,127,255}));
  connect(resistance.port_a, dumpTank.port_b)
    annotation (Line(points={{13,-20},{0,-20},{0,-2.4}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end DumpTank_Test;
