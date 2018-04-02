within TRANSFORM.Examples.SodiumFastReactor.Components;
model AirSideADHX

replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Intermediate heat system medium" annotation(choicesAllMatching=true);

 replaceable package Medium_Ambient =
      Modelica.Media.Air.DryAirNasa
    "Ambient medium" annotation(choicesAllMatching=true);

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toADHX(redeclare
      package Medium = Medium, R=50)
    annotation (Placement(transformation(extent={{-28,16},{-8,36}})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
        iconTransformation(extent={{-110,-30},{-90,-10}})));
  Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  HeatExchangers.GenericDistributed_HXold ADHX(
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
    p_a_start_shell=400000,
    p_b_start_shell=100000,
    T_a_start_shell=298.15,
    T_b_start_shell=323.15,
    p_a_start_tube=250000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,-20})));

  Modelica.Fluid.Sources.MassFlowSource_T blower(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    m_flow=300,
    T=298.15) annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{56,10},{36,30}})));
equation
  connect(resistance_toADHX.port_a, port_a) annotation (Line(points={{-25,26},{
          -62,26},{-62,-20},{-100,-20}}, color={0,127,255}));
  connect(resistance_toADHX.port_b, ADHX.port_a_tube)
    annotation (Line(points={{-11,26},{0,26},{0,-10}}, color={0,127,255}));
  connect(ADHX.port_b_tube, port_b)
    annotation (Line(points={{0,-30},{0,-60},{-100,-60}}, color={0,127,255}));
  connect(atmosphere.ports[1], ADHX.port_b_shell)
    annotation (Line(points={{36,20},{4.6,20},{4.6,-10}}, color={0,127,255}));
  connect(blower.ports[1], ADHX.port_a_shell) annotation (Line(points={{40,-60},
          {4.6,-60},{4.6,-30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Polygon(
          points={{0,30},{-44,10},{44,10},{0,30}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,10},{40,-80}},
          lineColor={0,0,0},
          fillColor={19,216,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-44},{60,-52},{70,-52},{70,-68},{60,-68},{40,-74},{40,-44}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{74,-72},{70,-80},{90,-80},{86,-72},{74,-72}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{94,-46},{66,-74}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-20},{20,-20},{-18,-40}}, color={238,46,47}),
        Line(points={{-18,-40},{18,-60},{-90,-60}}, color={28,108,200}),
        Text(
          extent={{-149,144},{151,104}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirSideADHX;
