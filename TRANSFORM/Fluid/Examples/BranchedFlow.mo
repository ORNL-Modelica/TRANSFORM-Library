within TRANSFORM.Fluid.Examples;
model BranchedFlow
  extends TRANSFORM.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.StandardWater;
  import Modelica.Fluid.Types.Dynamics;
  parameter Dynamics energyDynamics=Dynamics.SteadyStateInitial
    "Initialization: start the network in steady state";
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_in(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_a_start=10,
    Geometry(dimension=0.1, length=5))
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_inlet(
    redeclare package Medium = Medium,
    m_flow=10,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_a(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_a_start=5,
    Geometry(dimension=0.05, length=5))
                                 annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={10,-2})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_out(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Geometry(dimension=0.1, length=5))
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_b(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_a_start=5,
    Geometry(dimension=0.05, length=5))
                                 annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,0})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_outlet(
    redeclare package Medium = Medium,
    p=101325,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  TRANSFORM.Fluid.FittingsAndResistances.Elbow elbow_in(redeclare package
      Medium = Medium, m_flow_start=5)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  TRANSFORM.Fluid.FittingsAndResistances.Elbow elbow_out(redeclare package
      Medium = Medium, m_flow_start=5)
    annotation (Placement(transformation(extent={{60,-20},{80,-40}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolumeLoss tee_in(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    V=0.01,
    d_run=0.1,
    d_branch=0.05)
    annotation (Placement(transformation(extent={{0,40},{20,20}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolumeLoss tee_out(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    V=0.01,
    d_run=0.1,
    d_branch=0.05)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  TRANSFORM.Fluid.FittingsAndResistances.SmoothAdaptor adaptor_in(
    redeclare package Medium = Medium,
    m_flow_start=5,
    dimensions_ab={0.1,0.05},
    roughness=2.5e-5)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  TRANSFORM.Fluid.FittingsAndResistances.SmoothAdaptor adaptor_out(
    redeclare package Medium = Medium,
    m_flow_start=5,
    dimensions_ab={0.05,0.1},
    roughness=2.5e-5)
    annotation (Placement(transformation(extent={{50,-40},{30,-20}})));
equation
  connect(boundary_outlet.ports[1], pipe_out.port_b)
    annotation (Line(points={{-60,-30},{-40,-30}}, color={0,127,255}));
  connect(boundary_inlet.ports[1], pipe_in.port_a)
    annotation (Line(points={{-60,30},{-40,30}}, color={0,127,255}));
  connect(elbow_out.port_b, pipe_b.port_b) annotation (Line(points={{77,-30},{77,
          -20},{80,-20},{80,-10}}, color={0,127,255}));
  connect(elbow_in.port_b, pipe_b.port_a) annotation (Line(points={{77,30},{77,20},
          {80,20},{80,10}}, color={0,127,255}));
  connect(tee_in.port_1, pipe_in.port_b)
    annotation (Line(points={{0,30},{-20,30}}, color={0,127,255}));
  connect(tee_out.port_1, pipe_out.port_a)
    annotation (Line(points={{0,-30},{-20,-30}}, color={0,127,255}));
  connect(tee_out.port_3, pipe_a.port_b)
    annotation (Line(points={{10,-20},{10,-12}}, color={0,127,255}));
  connect(pipe_a.port_a, tee_in.port_3)
    annotation (Line(points={{10,8},{10,20}}, color={0,127,255}));
  connect(tee_in.port_2, adaptor_in.port_a)
    annotation (Line(points={{20,30},{33,30}}, color={0,127,255}));
  connect(adaptor_in.port_b, elbow_in.port_a)
    annotation (Line(points={{47,30},{63,30}}, color={0,127,255}));
  connect(tee_out.port_2, adaptor_out.port_b)
    annotation (Line(points={{20,-30},{33,-30}}, color={0,127,255}));
  connect(adaptor_out.port_a, elbow_out.port_a)
    annotation (Line(points={{47,-30},{63,-30}}, color={0,127,255}));
  annotation (experiment(StopTime=10), Documentation(info="<html>
<p>Water splits from a 0.1&nbsp;m header into two parallel paths and recombines: an immediate 0.05&nbsp;m branch
(<code>pipe_a</code>) straight off the header, and a run path through a reducer (<code>adaptor_in</code>), an
<code>elbow</code>, the 0.05&nbsp;m <code>pipe_b</code>, a second elbow and reducer. The dividing and recombining
junctions use <a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolumeLoss\">TeeJunctionVolumeLoss</a>.</p>
<p>All dynamic components are initialized in steady state (<code>energyDynamics=SteadyStateInitial</code>): a
split-and-recombine loop cannot find a consistent free-initial state, so the default <code>DynamicFreeInitial</code> makes
the nonlinear initialization fail.</p>
</html>"));
end BranchedFlow;
