within TRANSFORM.Examples.SodiumFastReactor.Components;
model AirHX

replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation(choicesAllMatching=true);

  Fluid.Pipes.GenericPipe_withWall pipe_AHX(
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    use_HeatTransferOuter=true,
    redeclare package Material = Media.Solids.SS304,
    T_a_start=data.T_IHX_outletIHTS,
    T_b_start=data.T_IHX_inletIHTS,
    T_a2_start=data.T_IHX_inletIHTS,
    T_a1_start=data.T_IHX_inletIHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        nR=3,
        dimension=data.D_tube_inner_AHX,
        length=data.length_tube_AHX,
        th_wall=data.th_tubewall_AHX,
        nV=2),
    nParallel=data.nTubes_AHX,
    m_flow_a_start=data.m_flow_IHX_IHTS/data.nAirHXs,
    p_a_start=250000,
    redeclare package Medium = Medium)
                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,0})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toAHX(redeclare
      package Medium = Medium, R=50)
    annotation (Placement(transformation(extent={{-28,16},{-8,36}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary_AHX(
      Q_flow=fill(-data.Qth_nominal_IHXs/boundary_AHX.nPorts/3, boundary_AHX.nPorts),
      nPorts=pipe_AHX.geometry.nV)
    annotation (Placement(transformation(extent={{38,-10},{18,10}})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(resistance_toAHX.port_a, port_a) annotation (Line(points={{-25,26},{-62,
          26},{-62,40},{-100,40}}, color={0,127,255}));
  connect(resistance_toAHX.port_b, pipe_AHX.port_a)
    annotation (Line(points={{-11,26},{0,26},{0,10}}, color={0,127,255}));
  connect(pipe_AHX.port_b, port_b)
    annotation (Line(points={{0,-10},{0,-40},{-100,-40}}, color={0,127,255}));
  connect(pipe_AHX.heatPorts, boundary_AHX.port)
    annotation (Line(points={{5,0},{18,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirHX;
