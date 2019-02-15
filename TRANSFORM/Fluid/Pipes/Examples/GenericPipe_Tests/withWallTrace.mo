within TRANSFORM.Fluid.Pipes.Examples.GenericPipe_Tests;
model withWallTrace
  import TRANSFORM;
extends TRANSFORM.Icons.Example;
  package Medium=Modelica.Media.Water.StandardWater(extraPropertiesNames={"Tritium"},
                                             C_nominal={1.519E-3});
  TRANSFORM.Fluid.Pipes.GenericPipe_wWall_wTraceMass
                                             pipe(
    redeclare package Material = TRANSFORM.Media.Solids.SS316,
    redeclare package Medium = Medium,
    m_flow_a_start=0.1,
    use_HeatTransferOuter=true,
    use_TraceMassTransferOuter=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        dimension=0.1,
        nR=1,
        nV=10),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics_wall=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_a_start=100000,
    T_a_start=323.15,
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
        (redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.PowerLawTemperature
            (D_ab0=6.4854e-26, n=5.7227)))
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
    use_C_in=true,
    T=293.15)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  inner TRANSFORM.Fluid.System    system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.Constant C(k=0.3*1.519E-3)
    "substance concentration, raising to 1000 PPM CO2"
    annotation (Placement(transformation(extent={{-132,-20},{-112,0}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration boundary[
    pipe.nV] annotation (Placement(transformation(extent={{-38,12},{-18,32}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary1[
    pipe.nV] annotation (Placement(transformation(extent={{28,12},{8,32}})));
  UserInteraction.Outputs.SpatialPlot plotC(
    minX=0,
    maxX=1,
    minY=0,
    maxY=4.5e-4,
    y=pipe.pipe.Cs[:, 1],
    x=x)
    "X - Axial Location (m) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{-24,-72},{30,-18}})));
    Real x[pipe.pipe.nV] = TRANSFORM.Math.cumulativeSum(pipe.pipe.geometry.dxs);
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={pipe.pipe.mediums[
        5].T,pipe.pipe.Cs[5, 1]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(Source.ports[1], pipe.port_a)
    annotation (Line(points={{-68,0},{-40,0},{-10,0}}, color={0,127,255}));
  connect(Sink.ports[1], pipe.port_b)
    annotation (Line(points={{50,0},{30,0},{10,0}}, color={0,127,255}));
  connect(C.y, Source.C_in[1]) annotation (Line(points={{-111,-10},{-100,-10},{
          -100,-8},{-88,-8}}, color={0,0,127}));
  connect(boundary1.port, pipe.heatPorts) annotation (Line(
      points={{8,22},{0,22},{0,5}},
      color={191,0,0},
      thickness));
  connect(boundary.port, pipe.massPorts) annotation (Line(
      points={{-18,22},{-4,22},{-4,5}},
      color={0,140,72},
      thickness));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100, __Dymola_Algorithm="Esdirk45a"));
end withWallTrace;
