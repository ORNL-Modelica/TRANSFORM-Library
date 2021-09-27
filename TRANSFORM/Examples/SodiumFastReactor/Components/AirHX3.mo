within TRANSFORM.Examples.SodiumFastReactor.Components;
model AirHX3
replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Intermediate heat system medium" annotation(choicesAllMatching=true);
 replaceable package Medium_Ambient =
      Modelica.Media.Air.DryAirNasa
    "Ambient medium" annotation(choicesAllMatching=true);
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toAHX(redeclare package
              Medium = Medium, R=50)
    annotation (Placement(transformation(extent={{-28,16},{-8,36}})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
        iconTransformation(extent={{-110,-30},{-90,-10}})));
  Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  HeatExchangers.GenericDistributed_HX    AHX(
    redeclare package Material_tubeWall = Media.Solids.SS304,
    redeclare package Medium_tube = Medium,
    m_flow_a_start_tube=data.m_flow_IHX_IHTS/data.nAirHXs,
    T_a_start_tube=data.T_IHX_outletIHTS,
    T_b_start_tube=data.T_IHX_inletIHTS,
    m_flow_a_start_shell=blower.m_flow,
    redeclare package Medium_shell = Medium_Ambient,
    useLumpedPressure_shell=true,
    useLumpedPressure_tube=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX (
        nR=3,
        D_o_shell=data.D_shell_outer_AHX,
        nTubes=data.nTubes_AHX,
        length_shell=data.height_active_shell_AHX,
        dimension_tube=data.D_tube_inner_AHX,
        length_tube=data.length_tube_AHX,
        th_wall=data.th_tubewall_AHX,
        surfaceArea_shell={data.surfaceArea_finnedTube},
        nV=2,
        angle_shell=1.5707963267949),
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer_AHX,
        S_T=data.pitch_tube_AHX,
        S_L=data.pitch_tube_AHX),
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
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
    use_m_flow_in=true,
    T=298.15) annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{56,10},{36,30}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_fromAHX(
    T_a_start=data.T_IHX_inletIHTS,
    redeclare package Medium = Medium,
    m_flow_a_start=data.m_flow_IHX_IHTS/data.nAirHXs,
    p_a_start=200000,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
         dimension=data.D_pipes_IHTStofromHXs, length=0.5*data.length_pipes_IHTStofromHXs))
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Fluid.Sensors.Temperature T_outlet_AHX_tube(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Controls.LimPID PID(
    Ti=10,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    k=-10,
    yb=300,
    k_s=1/data.T_IHX_inletIHTS,
    yMax=1000,
    k_m=1/data.T_IHX_inletIHTS)
           annotation (Placement(transformation(extent={{90,-62},{70,-42}})));
  Modelica.Blocks.Sources.Constant setpoint(k=data.T_IHX_inletIHTS)
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
equation
  connect(resistance_toAHX.port_a, port_a) annotation (Line(points={{-25,26},{-62,
          26},{-62,-20},{-100,-20}},
                                   color={0,127,255}));
  connect(resistance_toAHX.port_b, AHX.port_a_tube)
    annotation (Line(points={{-11,26},{0,26},{0,-10}}, color={0,127,255}));
  connect(atmosphere.ports[1], AHX.port_b_shell)
    annotation (Line(points={{36,20},{4.6,20},{4.6,-10}}, color={0,127,255}));
  connect(blower.ports[1], AHX.port_a_shell) annotation (Line(points={{40,-60},{
          4.6,-60},{4.6,-30}}, color={0,127,255}));
  connect(AHX.port_b_tube, pipe_fromAHX.port_a)
    annotation (Line(points={{0,-30},{0,-60},{-20,-60}}, color={0,127,255}));
  connect(pipe_fromAHX.port_b, port_b)
    annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
  connect(T_outlet_AHX_tube.port, pipe_fromAHX.port_a) annotation (Line(points=
          {{20,-90},{0,-90},{0,-60},{-20,-60}}, color={0,127,255}));
  connect(setpoint.y, PID.u_s) annotation (Line(points={{91,-20},{100,-20},{100,
          -52},{92,-52}}, color={0,0,127}));
  connect(T_outlet_AHX_tube.T, PID.u_m)
    annotation (Line(points={{26,-80},{80,-80},{80,-64}}, color={0,0,127}));
  connect(PID.y, blower.m_flow_in)
    annotation (Line(points={{69,-52},{60,-52}}, color={0,0,127}));
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
end AirHX3;
