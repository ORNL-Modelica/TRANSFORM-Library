within TRANSFORM.Examples.MoltenSaltReactor;
model decayheat2

  package Medium_DRACS = TRANSFORM.Media.Fluids.NaK.LinearNaK_22_78_pT;

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow    boundary_drainTank(Q_flow=
        6e6, use_port=true)
    annotation (Placement(transformation(extent={{138,-70},{118,-50}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_outer_drainTank(
    exposeState_b=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_thimbles - data_OFFGAS.th_thimbles,
    r_outer=0.5*data_OFFGAS.D_thimbles,
    T_start=data_OFFGAS.T_drainTank,
    exposeState_a=true)
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  HeatAndMassTransfer.Resistances.Heat.Radiation radiation_drainTank(
      surfaceArea=0.5*(thimble_inner_drainTank.surfaceArea_outer +
        thimble_outer_drainTank.surfaceArea_inner), epsilon=0.5)
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_inner_drainTank(
    exposeState_a=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_inner_thimbles - data_OFFGAS.th_inner_thimbles,
    r_outer=0.5*data_OFFGAS.D_inner_thimbles,
    T_start=data_OFFGAS.T_hot_dracs,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{-144,84},{-124,104}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_drainTank(nParallel
      =data_OFFGAS.nThimbles)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_drainTank(nParallel
      =data_OFFGAS.nThimbles)
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface thimbles_drainTank_fluid(
    nParallel=data_OFFGAS.nThimbles,
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_inner_thimbles - 2*data_OFFGAS.th_inner_thimbles,
          length=data_OFFGAS.length_thimbles),
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    showDesignFlowDirection=false,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_cold_dracs,
    T_b_start=data_OFFGAS.T_hot_dracs) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,-40})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_outer_waterTank(
    exposeState_b=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_thimbles - data_OFFGAS.th_thimbles,
    r_outer=0.5*data_OFFGAS.D_thimbles,
    exposeState_a=true,
    T_start=data_OFFGAS.T_inlet_waterTank)
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  HeatAndMassTransfer.Resistances.Heat.Radiation radiation_waterTank(
      surfaceArea=0.5*(thimble_inner_drainTank.surfaceArea_outer +
        thimble_outer_drainTank.surfaceArea_inner), epsilon=0.5)
    annotation (Placement(transformation(extent={{40,30},{20,50}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_inner_waterTank(
    exposeState_a=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_inner_thimbles - data_OFFGAS.th_inner_thimbles,
    r_outer=0.5*data_OFFGAS.D_inner_thimbles,
    exposeState_b=true,
    T_start=data_OFFGAS.T_cold_dracs)
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_waterTank(nParallel
      =data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_waterTank(nParallel
      =data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks)
    annotation (Placement(transformation(extent={{130,30},{110,50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface riser_DRACS(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    T_a_start=data_OFFGAS.T_hot_dracs,
    showDesignFlowDirection=false,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_OFFGAS.D_pipeToFrom_DRACS,
        length=data_OFFGAS.length_pipeToFrom_DRACS,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,-10})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface thimbles_waterTank_fluid(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_inner_thimbles - 2*data_OFFGAS.th_inner_thimbles,
          length=data_OFFGAS.length_thimbles),
    nParallel=data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks,
    showDesignFlowDirection=false,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_hot_dracs,
    T_b_start=data_OFFGAS.T_cold_dracs) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,30})));
  Fluid.Volumes.ExpansionTank waterTank(
    use_HeatPort=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=data_OFFGAS.crossArea_waterTank*data_OFFGAS.nWaterTanks,
    level_start=data_OFFGAS.level_nominal_waterTank,
    h_start=waterTank.Medium.specificEnthalpy_pT(waterTank.p_start, 0.5*(
        data_OFFGAS.T_inlet_waterTank + data_OFFGAS.T_outlet_waterTank)))
    annotation (Placement(transformation(extent={{130,58},{150,78}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_waterTank(
      surfaceArea=thimble_outer_waterTank.surfaceArea_outer, alpha=2000)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Fluid.BoundaryConditions.MassFlowSource_T source_waterTank(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=data_OFFGAS.T_inlet_waterTank,
    m_flow=10*data_OFFGAS.m_flow_inlet_waterTank*data_OFFGAS.nWaterTanks,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Fluid.BoundaryConditions.Boundary_pT sink_waterTank(
    T=data_OFFGAS.T_outlet_waterTank,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    p=100000) annotation (Placement(transformation(extent={{200,52},{180,72}})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium = Modelica.Media.Water.StandardWater, use_input=true)
    annotation (Placement(transformation(extent={{152,52},{172,72}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=waterTank.port_a.m_flow)
    annotation (Placement(transformation(extent={{140,78},{160,98}})));
  Controls.LimPID PID_waterTank(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yb=data_OFFGAS.m_flow_inlet_waterTank*data_OFFGAS.nWaterTanks,
    yMin=0) annotation (Placement(transformation(extent={{48,76},{68,96}})));
  Modelica.Blocks.Sources.RealExpression waterTank_m_flow_set(y=waterTank.state_liquid.T)
    annotation (Placement(transformation(extent={{20,76},{40,96}})));
  Modelica.Blocks.Sources.RealExpression waterTank_m_flow_meas(y=data_OFFGAS.T_outlet_waterTank)
    annotation (Placement(transformation(extent={{20,54},{40,74}})));
  Fluid.Volumes.ExpansionTank expansionTank_DRACS(
    redeclare package Medium = Medium_DRACS,
    h_start=data_OFFGAS.h_cold_dracs,
    A=2,
    level_start=1)
    annotation (Placement(transformation(extent={{-76,26},{-96,46}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface downcomer_DRACS(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_cold_dracs,
    showDesignFlowDirection=false,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_cold_dracs,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_OFFGAS.D_pipeToFrom_DRACS,
        length=data_OFFGAS.length_pipeToFrom_DRACS,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-100,-10})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium_DRACS, R=-1000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-100,16})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=3e6,
    freqHz=1/1000,
    offset=3e6)
    annotation (Placement(transformation(extent={{160,-70},{140,-50}})));
equation
  connect(radiation_drainTank.port_a, thimble_outer_drainTank.port_b)
    annotation (Line(points={{37,-60},{50,-60}}, color={191,0,0}));
  connect(thimble_inner_drainTank.port_a, radiation_drainTank.port_b)
    annotation (Line(points={{10,-60},{23,-60}}, color={191,0,0}));
  connect(thimble_outer_drainTank.port_a, nP_outer_drainTank.port_n)
    annotation (Line(points={{70,-60},{80,-60}}, color={191,0,0}));
  connect(nP_outer_drainTank.port_1, boundary_drainTank.port)
    annotation (Line(points={{100,-60},{118,-60}}, color={191,0,0}));
  connect(nP_inner_drainTank.port_n, thimble_inner_drainTank.port_b)
    annotation (Line(points={{-20,-60},{-10,-60}}, color={191,0,0}));
  connect(radiation_waterTank.port_a, thimble_outer_waterTank.port_b)
    annotation (Line(points={{37,40},{50,40}}, color={191,0,0}));
  connect(thimble_inner_waterTank.port_a, radiation_waterTank.port_b)
    annotation (Line(points={{10,40},{23,40}}, color={191,0,0}));
  connect(nP_inner_waterTank.port_n, thimble_inner_waterTank.port_b)
    annotation (Line(points={{-20,40},{-10,40}}, color={191,0,0}));
  connect(riser_DRACS.port_a, thimbles_drainTank_fluid.port_b) annotation (Line(
        points={{-50,-20},{-50,-40},{-70,-40}}, color={0,127,255}));
  connect(riser_DRACS.port_b, thimbles_waterTank_fluid.port_a)
    annotation (Line(points={{-50,0},{-50,30}}, color={0,127,255}));
  connect(thimble_outer_waterTank.port_a, convection_waterTank.port_a)
    annotation (Line(points={{70,40},{83,40}}, color={191,0,0}));
  connect(convection_waterTank.port_b, nP_outer_waterTank.port_n)
    annotation (Line(points={{97,40},{110,40}}, color={191,0,0}));
  connect(nP_outer_waterTank.port_1, waterTank.heatPort)
    annotation (Line(points={{130,40},{140,40},{140,59.6}}, color={191,0,0}));
  connect(source_waterTank.ports[1], waterTank.port_a) annotation (Line(points=
          {{100,70},{116,70},{116,62},{133,62}}, color={0,127,255}));
  connect(waterTank.port_b, pump_SimpleMassFlow.port_a)
    annotation (Line(points={{147,62},{152,62}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, sink_waterTank.ports[1])
    annotation (Line(points={{172,62},{180,62}}, color={0,127,255}));
  connect(realExpression.y, pump_SimpleMassFlow.in_m_flow)
    annotation (Line(points={{161,88},{162,88},{162,69.3}}, color={0,0,127}));
  connect(waterTank_m_flow_meas.y, PID_waterTank.u_m)
    annotation (Line(points={{41,64},{58,64},{58,74}}, color={0,0,127}));
  connect(waterTank_m_flow_set.y, PID_waterTank.u_s)
    annotation (Line(points={{41,86},{46,86}}, color={0,0,127}));
  connect(PID_waterTank.y, source_waterTank.m_flow_in) annotation (Line(points=
          {{69,86},{74,86},{74,78},{80,78}}, color={0,0,127}));
  connect(thimbles_waterTank_fluid.heatPorts[1, 1], nP_inner_waterTank.port_1)
    annotation (Line(points={{-60,35},{-60,40},{-40,40}}, color={191,0,0}));
  connect(expansionTank_DRACS.port_a, thimbles_waterTank_fluid.port_b)
    annotation (Line(points={{-79,30},{-70,30}}, color={0,127,255}));
  connect(downcomer_DRACS.port_b, thimbles_drainTank_fluid.port_a) annotation (
      Line(points={{-100,-20},{-100,-40},{-90,-40}}, color={0,127,255}));
  connect(resistance.port_b, downcomer_DRACS.port_a)
    annotation (Line(points={{-100,9},{-100,0}}, color={0,127,255}));
  connect(resistance.port_a, expansionTank_DRACS.port_b) annotation (Line(
        points={{-100,23},{-100,30},{-93,30}}, color={0,127,255}));
  connect(sine.y, boundary_drainTank.Q_flow_ext)
    annotation (Line(points={{139,-60},{132,-60}}, color={0,0,127}));
  connect(thimbles_drainTank_fluid.heatPorts[1, 1], nP_inner_drainTank.port_1)
    annotation (Line(points={{-80,-45},{-80,-60},{-40,-60}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,100}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end decayheat2;
