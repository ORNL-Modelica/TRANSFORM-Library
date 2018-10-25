within TRANSFORM.Examples.SodiumFastReactor.Components;
model DRACS_ADHX5

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
    redeclare package Medium = Medium,
    m_flow_a_start=data.m_flow_DRACSsec,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_tofromHXs_DRACS, length=data.length_pipes_tofromHXs_DRACS),
    p_a_start=400000,
    T_a_start=data.T_inlet_DRACSsec)
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_fromDRACS(
    redeclare package Medium = Medium,
    m_flow_a_start=data.m_flow_DRACSsec,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_tofromHXs_DRACS, length=data.length_pipes_tofromHXs_DRACS),
    p_a_start=300000,
    T_a_start=data.T_outlet_DRACSsec)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank(
      redeclare package Medium = Medium, R=1e6/data.m_flow_DRACSsec)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={22,-34})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));

  Fluid.Pipes.GenericPipe_withWall ADHX_tube(
    nParallel=data.nTubes_ADHX,
    redeclare package Medium = Medium,
    redeclare package Material = Media.Solids.SS304,
    use_HeatTransferOuter=true,
    m_flow_a_start=data.m_flow_DRACSsec,
    exposeState_b=true,
    T_a_start=data.T_outlet_DRACSsec,
    T_b_start=data.T_inlet_DRACSsec,
    T_a1_start=data.T_outlet_DRACSsec,
    T_a2_start=data.T_outlet_DRACSsec,
    counterCurrent=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        nV=2,
        dimension=data.D_tube_inner_ADHX,
        length=data.length_tube_ADHX,
        th_wall=data.th_tubewall_ADHX,
        nR=3),
    p_a_start=250000,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,-10})));

  Fluid.BoundaryConditions.Boundary_pT expansionTank(
    nPorts=1,
    redeclare package Medium = Medium,
    T=data.T_IHX_inletIHTS,
    p=100000) annotation (Placement(transformation(extent={{-12,-22},{8,-2}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower(
    redeclare package Medium = Medium_Ambient,
    m_flow=2,
    use_m_flow_in=true,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    p=100000,
    T=293.15,
    redeclare package Medium = Medium_Ambient,
    nPorts=1) annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                          ADHX_shell(
    use_HeatTransfer=true,
    redeclare package Medium = Medium_Ambient,
    m_flow_a_start=blower.m_flow,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.ShellSide_STHX
        (
        nV=2,
        nTubes=data.nTubes_ADHX,
        length_shell=data.height_active_shell_ADHX,
        D_o_shell=data.D_shell_outer_ADHX,
        length_tube=data.length_tube_ADHX,
        D_o_tube=data.D_tube_outer_ADHX,
        surfaceArea_shell=data.surfaceArea_finnedTube_ADHX,
        angle=1.5707963267949),
    p_a_start=100000,
    T_a_start=298.15,
    T_b_start=323.15,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer_AHX,
        S_T=data.pitch_tube_AHX,
        S_L=data.pitch_tube_AHX))
                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-10})));
  Fluid.Sensors.Temperature T_outlet_ADHX_tube(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Controls.LimPID PID(
    Ti=10,
    yMax=5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k_s=1/data.T_inlet_DRACSsec,
    k_m=1/data.T_inlet_DRACSsec,
    yMin=0,
    yb=2,
    k=-10) annotation (Placement(transformation(extent={{128,-62},{108,-42}})));
  Modelica.Blocks.Sources.Constant setpoint(k=data.T_inlet_DRACSsec)
    annotation (Placement(transformation(extent={{108,-30},{128,-10}})));
equation
  connect(pump.port_b, pipe_toDRACS.port_a)
    annotation (Line(points={{-40,-60},{-50,-60}}, color={0,127,255}));
  connect(pipe_fromDRACS.port_a, port_b)
    annotation (Line(points={{-70,40},{-100,40}}, color={0,127,255}));
  connect(pipe_toDRACS.port_b, port_a)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(ADHX_tube.port_a, pipe_fromDRACS.port_b)
    annotation (Line(points={{50,0},{50,40},{-50,40}}, color={0,127,255}));
  connect(ADHX_tube.port_b, pump.port_a)
    annotation (Line(points={{50,-20},{50,-60},{-20,-60}}, color={0,127,255}));
  connect(resistance_toExpTank.port_a, pump.port_a)
    annotation (Line(points={{22,-41},{22,-60},{-20,-60}}, color={0,127,255}));
  connect(expansionTank.ports[1], resistance_toExpTank.port_b)
    annotation (Line(points={{8,-12},{22,-12},{22,-27}}, color={0,127,255}));
  connect(T_outlet_ADHX_tube.port, pump.port_a) annotation (Line(points={{70,
          -90},{50,-90},{50,-60},{-20,-60}}, color={0,127,255}));
  connect(blower.m_flow_in, PID.y)
    annotation (Line(points={{100,-52},{107,-52}}, color={0,0,127}));
  connect(T_outlet_ADHX_tube.T, PID.u_m)
    annotation (Line(points={{76,-80},{118,-80},{118,-64}}, color={0,0,127}));
  connect(setpoint.y, PID.u_s) annotation (Line(points={{129,-20},{160,-20},{
          160,-52},{130,-52}},
                           color={0,0,127}));
  connect(ADHX_shell.port_b, atmosphere.ports[1])
    annotation (Line(points={{70,0},{70,20},{80,20}}, color={0,127,255}));
  connect(blower.ports[1], ADHX_shell.port_a)
    annotation (Line(points={{80,-60},{70,-60},{70,-20}}, color={0,127,255}));
  connect(ADHX_tube.heatPorts, ADHX_shell.heatPorts[:, 1])
    annotation (Line(points={{55,-10},{65,-10}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
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
          origin={80,0},
          rotation=90),
        Line(points={{80,18},{80,8},{90,6},{70,2},{80,0}}, color={238,46,47}),
        Line(
          points={{0,9},{0,-1},{10,-3},{-10,-7},{0,-9}},
          color={28,108,200},
          origin={80,-9},
          rotation=180),
        Ellipse(
          extent={{-66,-52},{-50,-68}},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(extent={{-10,-20},{10,-40}}, lineColor={0,0,0}),
        Line(points={{-90,40},{22,40}}, color={238,46,47}),
        Line(points={{80,22},{80,28},{30,28},{30,40},{22,40}}, color={238,46,47}),
        Line(points={{80,-22},{80,-28},{26,-28},{26,-60},{-44,-60}},
                                                                  color={28,108,
              200}),
        Line(points={{0,-60},{0,-42}}, color={28,108,200}),
        Line(points={{-90,-60},{-70,-60}}, color={28,108,200})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{160,100}})),
    experiment(StopTime=8460, __Dymola_NumberOfIntervals=846));
end DRACS_ADHX5;
