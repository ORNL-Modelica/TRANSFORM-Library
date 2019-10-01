within TRANSFORM.Fluid.Volumes.Examples;
model Pressurizer_Simple_Test

  extends TRANSFORM.Icons.Example;

  Pressurizer_Simple pressurizer(redeclare package Medium =
        Modelica.Media.Water.StandardWater, V_total=10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=true,
    T=373.15,
    nPorts=1) annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  BoundaryConditions.MassFlowSource_T boundary1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=true,
    T=573.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    rising=100,
    width=10,
    falling=100,
    period=250,
    nperiod=1,
    startTime=500)
    annotation (Placement(transformation(extent={{-100,26},{-80,46}})));
  Modelica.Blocks.Sources.Sine sine(amplitude=1, freqHz=1/100)
    annotation (Placement(transformation(extent={{-102,-40},{-82,-20}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={pressurizer.p})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundary1.ports[1], pressurizer.port_surge)
    annotation (Line(points={{-40,-32},{0,-32},{0,-10}}, color={0,127,255}));
  connect(boundary.ports[1], pressurizer.port_spray)
    annotation (Line(points={{-40,28},{0,28},{0,10}}, color={0,127,255}));
  connect(trapezoid.y, boundary.m_flow_in)
    annotation (Line(points={{-79,36},{-60,36}}, color={0,0,127}));
  connect(sine.y, boundary1.m_flow_in) annotation (Line(points={{-81,-30},{-70,
          -30},{-70,-24},{-60,-24}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10000, __Dymola_NumberOfIntervals=1000));
end Pressurizer_Simple_Test;
