within TRANSFORM.Examples.SodiumFastReactor.Components;
model IHTS2

  replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.LinearSodium_pT
    "Primary heat system medium" annotation(choicesAllMatching=true);

  Fluid.Machines.Pump pump(
    controlType="m_flow",
    T_start=data.T_start_cold,
    m_flow_nominal=data.m_flow_IHX_IHTS,
    redeclare package Medium = Medium,
    dp_nominal=400000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,-60})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_toIHX(
    T_a_start=data.T_IHX_inletIHTS,
    m_flow_a_start=data.m_flow_IHX_IHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_IHTStofromHXs, length=0.5*data.length_pipes_IHTStofromHXs),
    redeclare package Medium = Medium,
    p_a_start=400000)
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_fromIHX(
    T_a_start=data.T_IHX_outletIHTS,
    m_flow_a_start=data.m_flow_IHX_IHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_IHTStofromHXs, length=data.length_pipes_IHTStofromHXs),
    redeclare package Medium = Medium,
    p_a_start=300000)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Fluid.BoundaryConditions.Boundary_pT boundary_dummy(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=data.T_IHX_inletIHTS)
    annotation (Placement(transformation(extent={{112,-34},{104,-26}})));
  Fluid.Pipes.GenericPipe_withWall pipe_IHX(
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    use_HeatTransferOuter=true,
    nParallel=data.nTubes,
    T_a_start=data.T_IHX_inletIHTS,
    T_b_start=data.T_IHX_outletIHTS,
    m_flow_a_start=data.m_flow_IHX_IHTS,
    T_a1_start=data.T_IHX_inletIHTS,
    redeclare package Medium = Medium,
    redeclare package Material = Media.Solids.SS304,
    T_a2_start=data.T_IHX_inletIHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        dimension=data.D_tube_inner,
        length=data.length_tube,
        nR=3,
        th_wall=data.th_tubewall,
        angle=1.5707963267949,
        nV=2),
    p_a_start=350000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,0})));

  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Fluid.Pipes.GenericPipe_withWall pipe_AHX(
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    use_HeatTransferOuter=true,
    m_flow_a_start=data.m_flow_IHX_IHTS,
    redeclare package Medium = Medium,
    redeclare package Material = Media.Solids.SS304,
    nParallel=3*data.nTubes_AHX,
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
    p_a_start=200000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={90,0})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary(nPorts=
        pipe_IHX.geometry.nV, Q_flow=fill(data.Qth_nominal_IHXs/boundary.nPorts,
        boundary.nPorts))
    annotation (Placement(transformation(extent={{-126,-10},{-106,10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary1(nPorts=
        pipe_AHX.geometry.nV, Q_flow=fill(-data.Qth_nominal_IHXs/boundary1.nPorts,
        boundary1.nPorts))
    annotation (Placement(transformation(extent={{126,-10},{106,10}})));
  Fluid.BoundaryConditions.Boundary_pT boundary_dummy1(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=data.T_IHX_inletIHTS)
    annotation (Placement(transformation(extent={{2,-64},{-6,-56}})));
equation
  connect(pump.port_b, pipe_toIHX.port_a)
    annotation (Line(points={{-40,-60},{-60,-60}}, color={0,127,255}));
  connect(pipe_toIHX.port_b, pipe_IHX.port_a) annotation (Line(points={{-80,-60},
          {-90,-60},{-90,-10}}, color={0,127,255}));
  connect(pipe_fromIHX.port_a, pipe_IHX.port_b)
    annotation (Line(points={{-80,20},{-90,20},{-90,10}}, color={0,127,255}));
  connect(pipe_fromIHX.port_b, pipe_AHX.port_a)
    annotation (Line(points={{-60,20},{90,20},{90,10}}, color={0,127,255}));
  connect(boundary.port, pipe_IHX.heatPorts)
    annotation (Line(points={{-106,0},{-95,0}}, color={191,0,0}));
  connect(pipe_AHX.heatPorts, boundary1.port)
    annotation (Line(points={{95,0},{106,0}}, color={191,0,0}));
  connect(boundary_dummy1.ports[1], pump.port_a)
    annotation (Line(points={{-6,-60},{-20,-60}}, color={0,127,255}));
  connect(boundary_dummy.ports[1], pipe_AHX.port_b)
    annotation (Line(points={{104,-30},{90,-30},{90,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000));
end IHTS2;
