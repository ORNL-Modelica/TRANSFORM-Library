within TRANSFORM.Fluid.Pipes.Examples;
model UseOfGeometryModel
  "Comparing a circular with a non-circular pipe"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.StandardWater;

  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                     annotation(Placement(transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium,
    nPorts=2,
    p=10.0e5,
    T=293.15) annotation (Placement(transformation(origin={-80,0}, extent={{-10,
            -10},{10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T massflowsink1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=-0.1,
    T=293.15) annotation (Placement(transformation(origin={40,40}, extent={{10,
            -10},{-10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T massflowsink2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=-0.1,
    T=293.15) annotation (Placement(transformation(origin={40,-40}, extent={{10,
            -10},{-10,10}})));
TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
            circular_pipe(
  redeclare package Medium = Medium,
  energyDynamics=system.energyDynamics,
  m_flow_a_start=system.m_flow_start,
  momentumDynamics=system.momentumDynamics,
  exposeState_b=true,
  exposeState_a=false,
  p_a_start=1000000,
  p_b_start=1000000,
  T_a_start=293.15,
  redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=0.01, length=100)) annotation (Placement(transformation(
        origin={-20,40}, extent={{-10,-10},{10,10}})));
TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
            annulus_pipe(
  redeclare package Medium = Medium,
  exposeState_a=false,
  exposeState_b=true,
  energyDynamics=system.energyDynamics,
  m_flow_a_start=system.m_flow_start,
  momentumDynamics=system.momentumDynamics,
  p_a_start=1000000,
  p_b_start=1000000,
  T_a_start=293.15,
  redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightAnnulus
        (
      r_inner=0.5*0.005,
      r_outer=0.5*0.015,
      length=100)) annotation (Placement(transformation(origin={-20,-40},
        extent={{-10,-10},{10,10}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={circular_pipe.port_b.p,
        annulus_pipe.port_b.p})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundary.ports[1], circular_pipe.port_a) annotation(Line(points={{-70,2},
          {-60,2},{-60,40},{-30,40}},                                                                                   color = {0, 127, 255}));
  connect(boundary.ports[2], annulus_pipe.port_a) annotation(Line(points={{-70,-2},
          {-60,-2},{-60,-40},{-30,-40}},                                                                                 color = {0, 127, 255}));
  connect(circular_pipe.port_b, massflowsink1.ports[1]) annotation(Line(points = {{-10, 40}, {30, 40}}, color = {0, 127, 255}));
  connect(annulus_pipe.port_b, massflowsink2.ports[1]) annotation(Line(points = {{-10, -40}, {30, -40}}, color = {0, 127, 255}));
  annotation(experiment(StopTime=1),
  Documentation(info="<html>
<p>
In this example two pipes are used to demonstrate the use of circular (default) and non-circular pipes,
where the topmost pipe is circular with a length of 100 m and an inner diameter of 10 mm and the second pipe
is a circular ring pipe with inner diameter of 5 mm and an outer diameter of 15 mm.
</p>
<p>
Both pipes are connected to a pT source (water, 293.15 K, 10 bar) and a mass flow sink (0.1 kg/s inflow).
</p>
<p>
Although the hydraulic diameter of both pipes are the same, the different cross sections lead to different
velocities and by this different outlet pressures (7.324 bar for the circular pipe versus 9.231 bar for the
circular ring pipe).
</p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/NonCircularPipes.png\" border=\"1\"
     alt=\"NonCircularPipes.png\"></p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2015 by Alexander T&auml;schner:<br/>
First implementation.
</li>
</ul>
</html>"));
end UseOfGeometryModel;
