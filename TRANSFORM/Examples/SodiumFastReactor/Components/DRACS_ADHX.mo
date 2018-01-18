within TRANSFORM.Examples.SodiumFastReactor.Components;
model DRACS_ADHX

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
  Fluid.Volumes.ExpansionTank_1Port expansionTank(
    A=1,
    V0=0.001,
    level_start=1,
    h_start=data.h_start_IHTS_cold,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{12,-20},{32,0}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank1(
      redeclare package Medium = Medium, R=1/data.m_flow_DRACSsec) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={22,-34})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toPump(
      redeclare package Medium = Medium, R=1/data.m_flow_DRACSsec)
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  HeatExchangers.GenericDistributed_HX ADHX1(
    redeclare package Material_tubeWall = Media.Solids.SS304,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare package Medium_tube = Medium,
    T_a_start_tube=data.T_IHX_outletIHTS,
    T_b_start_tube=data.T_IHX_inletIHTS,
    m_flow_a_start_shell=blower.m_flow,
    redeclare package Medium_shell = Medium_Ambient,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        nV=2,
        D_o_shell=data.D_shell_outer_ADHX,
        nTubes=data.nTubes_ADHX,
        length_shell=data.height_active_shell_ADHX,
        surfaceArea_shell={data.surfaceArea_finnedTube_ADHX},
        angle_shell=1.5707963267949,
        dimension_tube=data.D_tube_inner_ADHX,
        length_tube=data.length_tube_ADHX,
        th_wall=data.th_tubewall_ADHX),
    m_flow_a_start_tube=data.m_flow_DRACSsec,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer_ADHX,
        S_T=data.pitch_tube_ADHX,
        S_L=data.pitch_tube_ADHX),
    exposeState_b_tube=true,
    p_a_start_shell=400000,
    p_b_start_shell=100000,
    T_a_start_shell=298.15,
    T_b_start_shell=323.15,
    p_a_start_tube=250000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={48,-6})));

  Modelica.Fluid.Sources.MassFlowSource_T blower(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    m_flow=100,
    T=298.15) annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower1(
    m_flow=data.m_flow_DRACS,
    T=data.T_IHX_inletPHTS,
    nPorts=1,
    redeclare package Medium = Medium)
              annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere1(
    nPorts=1,
    p=100000,
    T=data.T_IHX_inletPHTS,
    redeclare package Medium = Medium)
              annotation (Placement(transformation(extent={{-152,-52},{-132,-32}})));
equation
  connect(pump.port_b, pipe_toDRACS.port_a)
    annotation (Line(points={{-40,-60},{-50,-60}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_b, expansionTank.port)
    annotation (Line(points={{22,-27},{22,-18.4}}, color={0,127,255}));
  connect(resistance_toPump.port_a, pump.port_a)
    annotation (Line(points={{3,-60},{-20,-60}}, color={0,127,255}));
  connect(pipe_fromDRACS.port_a, port_b)
    annotation (Line(points={{-70,40},{-100,40}}, color={0,127,255}));
  connect(pipe_toDRACS.port_b, port_a)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(atmosphere.ports[1], ADHX1.port_b_shell)
    annotation (Line(points={{80,30},{52.6,30},{52.6,4}}, color={0,127,255}));
  connect(blower.ports[1], ADHX1.port_a_shell) annotation (Line(points={{80,-50},
          {52.6,-50},{52.6,-16}}, color={0,127,255}));
  connect(pipe_fromDRACS.port_b, ADHX1.port_a_tube)
    annotation (Line(points={{-50,40},{48,40},{48,4}}, color={0,127,255}));
  connect(ADHX1.port_b_tube, resistance_toPump.port_b)
    annotation (Line(points={{48,-16},{48,-60},{17,-60}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_a, resistance_toPump.port_b)
    annotation (Line(points={{22,-41},{22,-60},{17,-60}}, color={0,127,255}));
  connect(atmosphere1.ports[1], port_a) annotation (Line(points={{-132,-42},{
          -126,-42},{-126,-60},{-100,-60}}, color={0,127,255}));
  connect(blower1.ports[1], port_b) annotation (Line(points={{-120,40},{-100,40}},
                                color={0,127,255}));
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
    experiment(StopTime=1000));
end DRACS_ADHX;