within TRANSFORM.Examples.SodiumFastReactor.Components;
model IHTS3

  replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.LinearSodium_pT
    "Primary heat system medium" annotation(choicesAllMatching=true);

  Fluid.Machines.Pump_SimpleMassFlow pump(m_flow_nominal=data.m_flow_IHX_IHTS,
      redeclare package Medium = Medium) annotation (Placement(transformation(
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
    p_a_start=250000) annotation (Placement(transformation(
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
  Fluid.Volumes.ExpansionTank_1Port expansionTank(
    A=1,
    V0=0.001,
    level_start=1,
    h_start=data.h_start_IHTS_cold,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{22,-20},{42,0}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank1(
      redeclare package Medium = Medium, R=1/data.m_flow_IHX_IHTS) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={32,-34})));
  Fluid.Volumes.MixingVolume volume_toPump(
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (crossArea=
           1),
    redeclare package Medium = Medium,
    nPorts_b=2,
    nPorts_a=1,
    p_start=150000)
    annotation (Placement(transformation(extent={{56,-70},{36,-50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_toPump(
    T_a_start=data.T_IHX_inletIHTS,
    m_flow_a_start=data.m_flow_IHX_IHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_IHTStofromHXs, length=0.5*data.length_pipes_IHTStofromHXs),
    redeclare package Medium = Medium,
    p_a_start=200000)
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toPump(R=1/data.m_flow_IHX_IHTS,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
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
  connect(pipe_toPump.port_a, pipe_AHX.port_b)
    annotation (Line(points={{80,-60},{90,-60},{90,-10}}, color={0,127,255}));
  connect(volume_toPump.port_a[1], pipe_toPump.port_b)
    annotation (Line(points={{52,-60},{60,-60}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_a, volume_toPump.port_b[1]) annotation (
      Line(points={{32,-41},{32,-60.5},{40,-60.5}}, color={0,127,255}));
  connect(resistance_toPump.port_b, volume_toPump.port_b[2]) annotation (Line(
        points={{27,-60},{34,-60},{34,-59.5},{40,-59.5}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_b, expansionTank.port)
    annotation (Line(points={{32,-27},{32,-18.4}}, color={0,127,255}));
  connect(resistance_toPump.port_a, pump.port_a)
    annotation (Line(points={{13,-60},{-20,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-96,58},{-64,24}},
          color={0,0,0},
          pattern=LinePattern.None)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000));
end IHTS3;
