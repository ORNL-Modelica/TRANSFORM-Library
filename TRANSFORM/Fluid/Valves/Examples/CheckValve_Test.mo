within TRANSFORM.Fluid.Valves.Examples;
model CheckValve_Test
  extends TRANSFORM.Icons.Example;
  CheckValve checkValve_true(redeclare package Medium =
        Modelica.Media.Water.StandardWater, checkValve=true)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  BoundaryConditions.Boundary_pT source(
    p=200000,
    T=293.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=2,
    use_p_in=true,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1,
    amplitude=1e5,
    offset=2e5,
    phase=3.1415926535898)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  CheckValve checkValve_false(redeclare package Medium =
        Modelica.Media.Water.StandardWater, checkValve=false)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={checkValve_true.port_a.m_flow,
        checkValve_false.port_a.m_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(source.ports[1], checkValve_true.port_a) annotation (Line(points={{
          -40,2},{-20,2},{-20,10},{-10,10}}, color={0,127,255}));
  connect(checkValve_true.port_b, sink.ports[1]) annotation (Line(points={{10,
          10},{20,10},{20,2},{40,2}}, color={0,127,255}));
  connect(sine.y, sink.p_in)
    annotation (Line(points={{79,0},{70,0},{70,8},{62,8}}, color={0,0,127}));
  connect(checkValve_false.port_a, source.ports[2]) annotation (Line(points={{
          -10,-10},{-20,-10},{-20,-2},{-40,-2}}, color={0,127,255}));
  connect(checkValve_false.port_b, sink.ports[2]) annotation (Line(points={{10,
          -10},{20,-10},{20,-2},{40,-2}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end CheckValve_Test;
