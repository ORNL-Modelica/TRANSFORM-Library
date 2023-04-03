within TRANSFORM.Fluid.Volumes.Examples;
model MoistureSeparator_Test

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  BoundaryConditions.Boundary_ph sink1(
    nPorts=1,
    h=1e5,
    p=100000,
    redeclare package Medium = Medium)
           annotation (Placement(transformation(extent={{72,16},{52,36}})));
  FittingsAndResistances.SpecifiedResistance resistance1(
                                                   R=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{22,16},{42,36}})));
  FittingsAndResistances.SpecifiedResistance resistance2(
                                                   R=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-32,16},{-12,36}})));
  MoistureSeparator separator(
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=20),
    use_T_start=false,
    h_start=sink3.h,
    redeclare package Medium = Medium,
    p_start=100000)
    annotation (Placement(transformation(extent={{-6,16},{14,36}})));
  FittingsAndResistances.SpecifiedResistance resistance3(
                                                   R=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-6,-8})));
  BoundaryConditions.Boundary_ph sink2(
    nPorts=1,
    h=1e5,
    p=100000,
    redeclare package Medium = Medium)
           annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-6,-42})));
  BoundaryConditions.Boundary_ph sink3(
    nPorts=1,
    h=2.223e6,
    p=500000,
    redeclare package Medium = Medium)
           annotation (Placement(transformation(extent={{-76,16},{-56,36}})));
equation
  connect(resistance1.port_b, sink1.ports[1])
    annotation (Line(points={{39,26},{52,26}},   color={0,127,255}));
  connect(separator.port_Liquid, resistance3.port_a)
    annotation (Line(points={{0,22},{-6,22},{-6,-1}}, color={0,127,255}));
  connect(resistance3.port_b, sink2.ports[1])
    annotation (Line(points={{-6,-15},{-6,-32}}, color={0,127,255}));
  connect(resistance2.port_b, separator.port_a)
    annotation (Line(points={{-15,26},{-2,26}}, color={0,127,255}));
  connect(separator.port_b, resistance1.port_a)
    annotation (Line(points={{10,26},{25,26}}, color={0,127,255}));
  connect(sink3.ports[1], resistance2.port_a)
    annotation (Line(points={{-56,26},{-29,26}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment);
end MoistureSeparator_Test;
