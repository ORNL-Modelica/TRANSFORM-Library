within TRANSFORM.Fluid.Pipes.Examples.TransportDelayPipeTests;
model CheckDelayTime

  extends Icons.Example;

  package Medium=Modelica.Media.Water.StandardWater;

  TransportDelayPipe transportDelayPipe(
    redeclare package Medium = Medium,
    crossArea=0.01,
    length=1)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  BoundaryConditions.Boundary_pT boundary(
    nPorts=1,
    p=200000,
    T=293.15,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  BoundaryConditions.MassFlowSource_T boundary1(
    nPorts=1,
    m_flow=1,
    redeclare package Medium = Medium,
    use_X_in=false,
    use_C_in=false,
    use_m_flow_in=false,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  Modelica.Blocks.Sources.Step step2(
    height=20,
    offset=298.15,
    startTime=1)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Utilities.ErrorAnalysis.UnitTests           unitTests(n=3, x={
        transportDelayPipe.port_a.h_outflow,transportDelayPipe.port_b.h_outflow,
        transportDelayPipe.port_a.m_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundary1.ports[1], transportDelayPipe.port_a)
    annotation (Line(points={{-18,0},{-18,0},{-8,0}},  color={0,127,255}));
  connect(transportDelayPipe.port_b, boundary.ports[1]) annotation (Line(
      points={{12,0},{50,0}},
      color={0,127,255},
      thickness));

  connect(step2.y, boundary1.T_in) annotation (Line(points={{-59,10},{-50,10},{
          -50,4},{-40,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=11));
end CheckDelayTime;
