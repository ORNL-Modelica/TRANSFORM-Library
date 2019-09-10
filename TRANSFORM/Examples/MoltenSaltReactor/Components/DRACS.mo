within TRANSFORM.Examples.MoltenSaltReactor.Components;
model DRACS
  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;
  replaceable package Medium_DRACS =
      TRANSFORM.Media.Fluids.NaK.LinearNaK_22_78_pT constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  input SI.Area surfaceAreas_thimble[2] = fill(1,2)
    "Heat transfer surface area for gas and salt"
    annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alphas_drainTank[2]=fill(2000,2)
    "Convection heat transfer coefficient at thimble-drain tank interface for gas and salt"
    annotation (Dialog(group="Inputs"));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_outer_drainTank(
    exposeState_b=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_thimbles - data_OFFGAS.th_thimbles,
    r_outer=0.5*data_OFFGAS.D_thimbles,
    T_start=data_OFFGAS.T_drainTank,
    exposeState_a=true,
    showName=false)
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  HeatAndMassTransfer.Resistances.Heat.Radiation radiation_drainTank(
      surfaceArea=0.5*(thimble_inner_drainTank.surfaceArea_outer +
        thimble_outer_drainTank.surfaceArea_inner), epsilon=0.5,
    showName=false)
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_inner_drainTank(
    exposeState_a=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_inner_thimbles - data_OFFGAS.th_inner_thimbles,
    r_outer=0.5*data_OFFGAS.D_inner_thimbles,
    T_start=data_OFFGAS.T_hot_dracs,
    exposeState_b=true,
    showName=false)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{180,80},{200,100}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_drainTank(
      nParallel=data_OFFGAS.nThimbles, showName=false)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_drainTank[2](each
      nParallel=data_OFFGAS.nThimbles, each showName=false)
    annotation (Placement(transformation(extent={{148,-70},{128,-50}})));
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
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_cold_dracs,
    T_b_start=data_OFFGAS.T_hot_dracs,
    showName=false)                    annotation (Placement(transformation(
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
    T_start=data_OFFGAS.T_inlet_waterTank,
    showName=false)
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  HeatAndMassTransfer.Resistances.Heat.Radiation radiation_waterTank(
      surfaceArea=0.5*(thimble_inner_drainTank.surfaceArea_outer +
        thimble_outer_drainTank.surfaceArea_inner), epsilon=0.5,
    showName=false)
    annotation (Placement(transformation(extent={{40,30},{20,50}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder thimble_inner_waterTank(
    exposeState_a=true,
    redeclare package Material = Media.Solids.AlloyN,
    length=data_OFFGAS.length_thimbles,
    r_inner=0.5*data_OFFGAS.D_inner_thimbles - data_OFFGAS.th_inner_thimbles,
    r_outer=0.5*data_OFFGAS.D_inner_thimbles,
    exposeState_b=true,
    T_start=data_OFFGAS.T_cold_dracs,
    showName=false)
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_inner_waterTank(
      nParallel=data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks, showName=
       false)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.ParallelFlow nP_outer_waterTank(
      nParallel=data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks, showName=
       false)
    annotation (Placement(transformation(extent={{130,30},{110,50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface riser_DRACS(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    T_a_start=data_OFFGAS.T_hot_dracs,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_OFFGAS.D_pipeToFrom_DRACS,
        length=data_OFFGAS.length_pipeToFrom_DRACS,
        angle=1.5707963267949),
    showName=false)             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,-10})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface thimbles_waterTank_fluid(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_hot_dracs,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    nParallel=data_OFFGAS.nThimbles_waterTank*data_OFFGAS.nWaterTanks,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_hot_dracs,
    T_b_start=data_OFFGAS.T_cold_dracs,
    showName=false,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data_OFFGAS.D_inner_thimbles - 2*data_OFFGAS.th_inner_thimbles,
          length=data_OFFGAS.length_thimbles_waterTank))
                                        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,30})));
  Fluid.Volumes.ExpansionTank waterTank(
    use_HeatPort=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=data_OFFGAS.crossArea_waterTank*data_OFFGAS.nWaterTanks,
    level_start=data_OFFGAS.level_nominal_waterTank,
    h_start=waterTank.Medium.specificEnthalpy_pT(waterTank.p_start, 0.5*(
        data_OFFGAS.T_inlet_waterTank + data_OFFGAS.T_outlet_waterTank)),
    showName=false)
    annotation (Placement(transformation(extent={{130,58},{150,78}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_waterTank(
      surfaceArea=thimble_outer_waterTank.surfaceArea_outer, alpha=2000,
    showName=false)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Fluid.BoundaryConditions.MassFlowSource_T source_waterTank(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=data_OFFGAS.T_inlet_waterTank,
    m_flow=10*data_OFFGAS.m_flow_inlet_waterTank*data_OFFGAS.nWaterTanks,
    use_m_flow_in=true,
    showName=false)
    annotation (Placement(transformation(extent={{80,52},{100,72}})));
  Fluid.BoundaryConditions.Boundary_pT sink_waterTank(
    T=data_OFFGAS.T_outlet_waterTank,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    p=100000,
    showName=false)
              annotation (Placement(transformation(extent={{200,52},{180,72}})));
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
    level_start=1,
    showName=false)
    annotation (Placement(transformation(extent={{-76,26},{-96,46}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface downcomer_DRACS(
    redeclare package Medium = Medium_DRACS,
    m_flow_a_start=data_OFFGAS.m_flow_cold_dracs,
    showColors=true,
    val_min=data_OFFGAS.T_cold_dracs,
    val_max=data_OFFGAS.T_hot_dracs,
    T_a_start=data_OFFGAS.T_cold_dracs,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data_OFFGAS.D_pipeToFrom_DRACS,
        length=data_OFFGAS.length_pipeToFrom_DRACS,
        angle=1.5707963267949),
    showName=false)             annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-100,-10})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium_DRACS,
    showName=false,
    R=-2000)                          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-100,16})));
  HeatAndMassTransfer.Interfaces.HeatPort_Flow port_thimbleWall[2] annotation (
      Placement(transformation(extent={{162,-70},{182,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_outer_drainTank[2](
    surfaceArea=surfaceAreas_thimble, alpha=alphas_drainTank,
    each showName=false)
    "thimble_outer_drainTank.surfaceArea_outer"
    annotation (Placement(transformation(extent={{104,-70},{124,-50}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Collector collector(n=2, showName=
       false)
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
equation
  connect(radiation_drainTank.port_a, thimble_outer_drainTank.port_b)
    annotation (Line(points={{37,-60},{50,-60}}, color={191,0,0}));
  connect(thimble_inner_drainTank.port_a, radiation_drainTank.port_b)
    annotation (Line(points={{10,-60},{23,-60}}, color={191,0,0}));
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
  connect(source_waterTank.ports[1], waterTank.port_a)
    annotation (Line(points={{100,62},{133,62}}, color={0,127,255}));
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
  connect(PID_waterTank.y, source_waterTank.m_flow_in) annotation (Line(points={
          {69,86},{74,86},{74,70},{80,70}}, color={0,0,127}));
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
  connect(thimbles_drainTank_fluid.heatPorts[1, 1], nP_inner_drainTank.port_1)
    annotation (Line(points={{-80,-45},{-80,-60},{-40,-60}}, color={191,0,0}));
  connect(thimble_outer_drainTank.port_a, collector.port_b)
    annotation (Line(points={{70,-60},{80,-60}}, color={191,0,0}));
  connect(collector.port_a, convection_outer_drainTank.port_a)
    annotation (Line(points={{100,-60},{107,-60}}, color={191,0,0}));
  connect(convection_outer_drainTank.port_b, nP_outer_drainTank.port_n)
    annotation (Line(points={{121,-60},{124,-60},{124,-60},{128,-60}}, color={191,
          0,0}));
  connect(nP_outer_drainTank.port_1, port_thimbleWall) annotation (Line(points={{148,-60},
          {172,-60}},                               color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{40,-30},{94,-86}},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{84,-30},{78,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={230,230,230}),
        Rectangle(
          extent={{70,-30},{64,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={230,230,230}),
        Rectangle(
          extent={{56,-30},{50,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={230,230,230}),
        Rectangle(
          extent={{74,48},{60,-20}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-20,80},{40,40}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,60},{40,48}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{40,60},{-20,56}},
          lineColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={230,230,230}),
        Rectangle(
          extent={{40,50},{-20,46}},
          lineColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={230,230,230}),
        Rectangle(
          extent={{-20,60},{-62,46}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,86},{-84,60}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Sphere,
          fillColor={28,108,200}),
        Rectangle(
          extent={{-62,60},{-80,-20}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{5,60},{-5,-60}},
          lineColor={28,108,200},
          origin={-20,-25},
          rotation=90,
          fillColor={28,108,200},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{40,-20},{94,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={230,230,230}),
        Ellipse(
          extent={{-84,60},{-58,86}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          startAngle=0,
          endAngle=180),
        Rectangle(
          extent={{-20,80},{40,64}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,134},{151,94}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{200,
            100}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end DRACS;
