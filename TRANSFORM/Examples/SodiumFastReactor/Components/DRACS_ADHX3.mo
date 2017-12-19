within TRANSFORM.Examples.SodiumFastReactor.Components;
model DRACS_ADHX3

replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation(choicesAllMatching=true);

 replaceable package Medium_Ambient =
      Modelica.Media.Air.DryAirNasa
    "Ambient medium" annotation(choicesAllMatching=true);

  Fluid.Machines.Pump_SimpleMassFlow pump(
      redeclare package Medium = Medium, m_flow_nominal=data.m_flow_DRACSsec)
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,-60})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_toDRACS(
    T_a_start=data.T_IHX_inletIHTS,
    redeclare package Medium = Medium,
    m_flow_a_start=data.m_flow_DRACSsec,
    p_a_start=400000,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_tofromHXs_DRACS, length=data.length_pipes_tofromHXs_DRACS))
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_fromDRACS(
    T_a_start=data.T_IHX_outletIHTS,
    redeclare package Medium = Medium,
    m_flow_a_start=data.m_flow_DRACSsec,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_tofromHXs_DRACS, length=data.length_pipes_tofromHXs_DRACS),
    p_a_start=300000)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank1(
      redeclare package Medium = Medium, R=1e6/data.m_flow_DRACSsec)
                                                                   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={22,-34})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));

  Fluid.Pipes.GenericPipe_withWall pipe(
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        nR=3,
        nV=2,
        dimension=data.D_tube_inner_ADHX,
        length=data.length_tube_ADHX,
        th_wall=data.th_tubewall_ADHX),
    nParallel=data.nTubes_ADHX,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare package Material = Media.Solids.SS304,
    use_HeatTransferOuter=true,
    T_a_start=data.T_IHX_outletIHTS,
    T_b_start=data.T_IHX_inletIHTS,
    m_flow_a_start=data.m_flow_DRACSsec,
    T_a1_start=data.T_IHX_outletIHTS,
    T_a2_start=data.T_IHX_inletIHTS,
    p_a_start=250000,
    exposeState_b=true) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,-10})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary[2](Q_flow=-750e3
        /2) annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Fluid.Pipes.GenericPipe_withWall pipe1(
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare package Material = Media.Solids.SS304,
    use_HeatTransferOuter=true,
    m_flow_a_start=data.m_flow_DRACSsec,
    T_a_start=data.T_IHX_inletIHTS,
    T_b_start=data.T_IHX_outletIHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        nR=3,
        nV=2,
        dimension=data.D_tube_innerDRACS,
        length=data.length_tubeDRACS,
        angle=1.5707963267949,
        th_wall=data.th_tubewallDRACS),
    nParallel=data.nTubes_DRACS,
    p_a_start=350000,
    T_a1_start=data.T_IHX_inletIHTS,
    T_a2_start=data.T_IHX_outletIHTS) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,-10})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary1[2](Q_flow=
        750e3/2)
    annotation (Placement(transformation(extent={{-136,-20},{-116,0}})));
  Fluid.BoundaryConditions.Boundary_pT boundary2(
    nPorts=1,
    redeclare package Medium = Medium,
    p=100000,
    T=data.T_IHX_inletIHTS)
    annotation (Placement(transformation(extent={{-12,-22},{8,-2}})));
equation
  connect(pump.port_b, pipe_toDRACS.port_a)
    annotation (Line(points={{-40,-60},{-50,-60}}, color={0,127,255}));
  connect(pipe_fromDRACS.port_a, port_b)
    annotation (Line(points={{-70,40},{-100,40}}, color={0,127,255}));
  connect(pipe_toDRACS.port_b, port_a)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(pipe.port_a, pipe_fromDRACS.port_b)
    annotation (Line(points={{50,0},{50,40},{-50,40}}, color={0,127,255}));
  connect(pipe.heatPorts, boundary.port)
    annotation (Line(points={{55,-10},{60,-10}}, color={191,0,0}));
  connect(pipe1.port_a, port_a)
    annotation (Line(points={{-100,-20},{-100,-60}}, color={0,127,255}));
  connect(pipe1.port_b, port_b)
    annotation (Line(points={{-100,0},{-100,40}}, color={0,127,255}));
  connect(boundary1.port, pipe1.heatPorts)
    annotation (Line(points={{-116,-10},{-105,-10}}, color={191,0,0}));
  connect(pipe.port_b, pump.port_a)
    annotation (Line(points={{50,-20},{50,-60},{-20,-60}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_a, pump.port_a)
    annotation (Line(points={{22,-41},{22,-60},{-20,-60}}, color={0,127,255}));
  connect(boundary2.ports[1], resistance_toExpTank1.port_b)
    annotation (Line(points={{8,-12},{22,-12},{22,-27}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{76,80}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{30,102}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-60,-24}},
          pattern=LinePattern.None,
          thickness=0.5),
        Text(
          extent={{-149,144},{151,104}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-62,-58},{-46,-62}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-52},{-58,-56}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,-20},{10,-40}},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,-18},{12,-30}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          origin={80,60},
          rotation=90),
        Line(points={{80,78},{80,68},{90,66},{70,62},{80,60}}, color={238,46,47}),
        Line(
          points={{0,9},{0,-1},{10,-3},{-10,-7},{0,-9}},
          color={28,108,200},
          origin={80,51},
          rotation=180),
        Rectangle(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          origin={80,0},
          rotation=90),
        Line(points={{80,18},{80,8},{90,6},{70,2},{80,0}}, color={238,46,47}),
        Line(
          points={{0,9},{0,-1},{10,-3},{-10,-7},{0,-9}},
          color={28,108,200},
          origin={80,-9},
          rotation=180),
        Rectangle(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          origin={80,-60},
          rotation=90),
        Line(points={{80,-42},{80,-52},{90,-54},{70,-58},{80,-60}}, color={238,
              46,47}),
        Line(
          points={{0,9},{0,-1},{10,-3},{-10,-7},{0,-9}},
          color={28,108,200},
          origin={80,-69},
          rotation=180),
        Ellipse(
          extent={{-66,-52},{-50,-68}},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(extent={{-10,-20},{10,-40}}, lineColor={0,0,0}),
        Line(points={{-90,40},{22,40}}, color={238,46,47}),
        Line(points={{80,82},{80,88},{30,88},{30,54},{30,40}}, color={238,46,47}),
        Line(points={{80,22},{80,28},{30,28},{30,40},{22,40}}, color={238,46,47}),
        Line(points={{80,-38},{80,-32},{30,-32},{30,24},{30,28}}, color={238,46,
              47}),
        Line(points={{80,38},{80,32},{26,32},{26,-60},{-44,-60}}, color={28,108,
              200}),
        Line(points={{80,-22},{80,-28},{28,-28}}, color={28,108,200}),
        Line(points={{80,-82},{80,-88},{26,-88},{26,-60}}, color={28,108,200}),
        Line(points={{0,-60},{0,-42}}, color={28,108,200}),
        Line(points={{-90,-60},{-70,-60}}, color={28,108,200}),
        Ellipse(
          extent={{18,-52},{34,-68}},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{22,48},{38,32}},
          lineThickness=0.5,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=8460, __Dymola_NumberOfIntervals=846));
end DRACS_ADHX3;
