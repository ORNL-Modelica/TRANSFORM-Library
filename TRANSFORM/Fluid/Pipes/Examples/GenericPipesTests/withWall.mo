within TRANSFORM.Fluid.Pipes.Examples.GenericPipesTests;
model withWall
  import TRANSFORM;
extends TRANSFORM.Icons.Example;
  package Medium=Modelica.Media.Water.StandardWater(extraPropertiesNames={"Tritium"},
                                             C_nominal={1.519E-3});
  TRANSFORM.Fluid.Pipes.GenericPipe_withWall pipe(
    redeclare package Material = TRANSFORM.Media.Solids.SS316,
    redeclare package Medium = Medium,
    m_flow_a_start=0.1,
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        dimension=0.1,
        nV=1,
        nR=1),
    use_HeatTransferOuter=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_a_start=100000,
    T_a_start=323.15,
    energyDynamics_wall=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT Sink(
    nPorts=1,
    p=100000,
    T=323.15,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T Source(
    nPorts=1,
    m_flow=0.05,
    redeclare package Medium = Medium,
    use_C_in=false,
    T=293.15)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  inner TRANSFORM.Fluid.System    system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary1[
    pipe.nV] annotation (Placement(transformation(extent={{28,12},{8,32}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={pipe.pipe.mediums[1].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(Source.ports[1], pipe.port_a)
    annotation (Line(points={{-68,0},{-40,0},{-10,0}}, color={0,127,255}));
  connect(Sink.ports[1], pipe.port_b)
    annotation (Line(points={{50,0},{30,0},{10,0}}, color={0,127,255}));
  connect(boundary1.port, pipe.heatPorts) annotation (Line(
      points={{8,22},{0,22},{0,5}},
      color={191,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end withWall;
