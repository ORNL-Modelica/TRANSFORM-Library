within TRANSFORM.Examples.MoltenSaltReactor;
model decayheat

  package Medium_DRACS = TRANSFORM.Media.Fluids.NaK.LinearNaK_22_78_pT;

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow    boundary_drainTank(Q_flow=
        6e6)
    annotation (Placement(transformation(extent={{138,-30},{118,-10}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_outer_drainTank(
    exposeState_b=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_thimbles - data_OFFGAS.th_thimbles,
    r_outer=0.5*data_OFFGAS.D_thimbles,
    T_start=data_OFFGAS.T_drainTank,
    exposeState_a=true)
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  HeatAndMassTransfer.Resistances.Heat.Radiation radiation_drainTank(
      surfaceArea=0.5*(thimble_inner_drainTank.surfaceArea_outer +
        thimble_outer_drainTank.surfaceArea_inner), epsilon=0.5)
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_inner_drainTank(
    exposeState_a=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_inner_thimbles - data_OFFGAS.th_inner_thimbles,
    r_outer=0.5*data_OFFGAS.D_inner_thimbles,
    T_start=data_OFFGAS.T_hot_dracs,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{-8,80},{12,100}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_drainTank(nParallel=
       data_OFFGAS.nThimbles)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_drainTank(nParallel=
       data_OFFGAS.nThimbles)
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    nParallel=data_OFFGAS.nThimbles,
    redeclare package Medium = Medium_DRACS,
    T_a_start=data_OFFGAS.T_cold_dracs,
    T_b_start=data_OFFGAS.T_hot_dracs,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_inner_thimbles - 2*data_OFFGAS.th_inner_thimbles,
          length=data_OFFGAS.length_thimbles),
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,-20})));
  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium_DRACS,
    T=data_OFFGAS.T_hot_dracs,
    p=100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=data_OFFGAS.m_flow_hot_dracs,
    T=data_OFFGAS.T_cold_dracs,
    redeclare package Medium = Medium_DRACS)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
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
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_waterTank(nParallel=
       data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_waterTank(nParallel=
       data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks)
    annotation (Placement(transformation(extent={{130,30},{110,50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe1(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_pipeToFrom_DRACS, length=data_OFFGAS.length_pipeToFrom_DRACS),
    T_a_start=data_OFFGAS.T_hot_dracs) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,10})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe2(
    redeclare package Medium = Medium_DRACS,
    T_a_start=data_OFFGAS.T_cold_dracs,
    T_b_start=data_OFFGAS.T_hot_dracs,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_inner_thimbles - 2*data_OFFGAS.th_inner_thimbles,
          length=data_OFFGAS.length_thimbles),
    nParallel=data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,40})));

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
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=data_OFFGAS.T_inlet_waterTank,
    m_flow=10*data_OFFGAS.m_flow_inlet_waterTank*data_OFFGAS.nWaterTanks,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Fluid.BoundaryConditions.Boundary_pT boundary3(
    T=data_OFFGAS.T_outlet_waterTank,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    nPorts=1) annotation (Placement(transformation(extent={{200,52},{180,72}})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
              Medium =
               Modelica.Media.Water.StandardWater, use_input=true)
    annotation (Placement(transformation(extent={{152,52},{172,72}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=waterTank.port_a.m_flow)
    annotation (Placement(transformation(extent={{140,78},{160,98}})));
  Controls.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yb=data_OFFGAS.m_flow_inlet_waterTank*data_OFFGAS.nWaterTanks,
    yMin=0) annotation (Placement(transformation(extent={{48,76},{68,96}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=waterTank.state_liquid.T)
    annotation (Placement(transformation(extent={{20,76},{40,96}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=data_OFFGAS.T_outlet_waterTank)
    annotation (Placement(transformation(extent={{20,54},{40,74}})));
equation
  connect(radiation_drainTank.port_a, thimble_outer_drainTank.port_b)
    annotation (Line(points={{37,-20},{50,-20}}, color={191,0,0}));
  connect(thimble_inner_drainTank.port_a, radiation_drainTank.port_b)
    annotation (Line(points={{10,-20},{23,-20}}, color={191,0,0}));
  connect(thimble_outer_drainTank.port_a, nP_outer_drainTank.port_n)
    annotation (Line(points={{70,-20},{80,-20}}, color={191,0,0}));
  connect(nP_outer_drainTank.port_1, boundary_drainTank.port)
    annotation (Line(points={{100,-20},{118,-20}}, color={191,0,0}));
  connect(nP_inner_drainTank.port_n, thimble_inner_drainTank.port_b)
    annotation (Line(points={{-20,-20},{-10,-20}}, color={191,0,0}));
  connect(pipe.heatPorts[1, 1], nP_inner_drainTank.port_1)
    annotation (Line(points={{-55,-20},{-40,-20}}, color={191,0,0}));
  connect(boundary2.ports[1], pipe.port_a) annotation (Line(points={{-80,-60},{
          -60,-60},{-60,-30}}, color={0,127,255}));
  connect(radiation_waterTank.port_a, thimble_outer_waterTank.port_b)
    annotation (Line(points={{37,40},{50,40}}, color={191,0,0}));
  connect(thimble_inner_waterTank.port_a, radiation_waterTank.port_b)
    annotation (Line(points={{10,40},{23,40}}, color={191,0,0}));
  connect(nP_inner_waterTank.port_n, thimble_inner_waterTank.port_b)
    annotation (Line(points={{-20,40},{-10,40}}, color={191,0,0}));
  connect(pipe1.port_a, pipe.port_b)
    annotation (Line(points={{-60,0},{-60,-10}}, color={0,127,255}));
  connect(boundary.ports[1], pipe2.port_b)
    annotation (Line(points={{-80,60},{-60,60},{-60,50}}, color={0,127,255}));
  connect(pipe1.port_b, pipe2.port_a)
    annotation (Line(points={{-60,20},{-60,30}}, color={0,127,255}));
  connect(pipe2.heatPorts[1, 1], nP_inner_waterTank.port_1)
    annotation (Line(points={{-55,40},{-40,40}}, color={191,0,0}));
  connect(thimble_outer_waterTank.port_a, convection_waterTank.port_a)
    annotation (Line(points={{70,40},{83,40}}, color={191,0,0}));
  connect(convection_waterTank.port_b, nP_outer_waterTank.port_n)
    annotation (Line(points={{97,40},{110,40}}, color={191,0,0}));
  connect(nP_outer_waterTank.port_1, waterTank.heatPort)
    annotation (Line(points={{130,40},{140,40},{140,59.6}}, color={191,0,0}));
  connect(boundary1.ports[1], waterTank.port_a) annotation (Line(points={{100,
          70},{116,70},{116,62},{133,62}}, color={0,127,255}));
  connect(waterTank.port_b, pump_SimpleMassFlow.port_a)
    annotation (Line(points={{147,62},{152,62}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, boundary3.ports[1])
    annotation (Line(points={{172,62},{180,62}}, color={0,127,255}));
  connect(realExpression.y, pump_SimpleMassFlow.in_m_flow)
    annotation (Line(points={{161,88},{162,88},{162,69.3}}, color={0,0,127}));
  connect(realExpression2.y, PID.u_m)
    annotation (Line(points={{41,64},{58,64},{58,74}}, color={0,0,127}));
  connect(realExpression1.y, PID.u_s)
    annotation (Line(points={{41,86},{46,86}}, color={0,0,127}));
  connect(PID.y, boundary1.m_flow_in) annotation (Line(points={{69,86},{74,86},
          {74,78},{80,78}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,100}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end decayheat;
