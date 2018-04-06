within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model HP_turbine
  parameter Real eta_is=0.88 "Turbine isentropic efficiency";
  parameter Real eta_mech=0.998 "Turbine mechanical efficiency";
  replaceable package Medium =
      Modelica.Media.Water.StandardWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter Integer N_drain_stage1r=1   "Number of drain_stage1r ports" annotation(Dialog(connectorSizing=true));
  parameter Integer N_drain_stage2r=1   "Number of drain_stage2r ports" annotation(Dialog(connectorSizing=true));

  parameter Records.RankineNominalValues nominalData "Nominal data"
    annotation (Dialog(group="Nominal operating data"), Placement(
        transformation(extent={{40,73},{60,94}})));

  Machines.SteamTurbine stage1(
    eta_mech=eta_mech,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Eta_wetSteam =
        Machines.BaseClasses.WetSteamEfficiency.eta_Constant (eta_nominal=
            eta_is),
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1,
    T_nominal=nominalData.T_nom_turbine_HP_stage1_feed,
    p_inlet_nominal=nominalData.p_nom_turbine_HP_stage1_feed,
    p_outlet_nominal=nominalData.p_nom_turbine_HP_stage1_drain,
    p_a_start=initData.p_start_turbine_HP_stage1_feed,
    p_b_start=initData.p_start_turbine_HP_stage1_drain,
    use_T_start=false,
    h_a_start=stage1.Medium.specificEnthalpy_pTX(
        stage1.p_a_start,
        initData.T_start_turbine_HP_stage1_feed,
        stage1.Medium.reference_X),
    h_b_start=stage1.Medium.specificEnthalpy_pTX(
        stage1.p_b_start,
        initData.T_start_turbine_IP_drain,
        stage1.Medium.reference_X),
    m_flow_start=nominalData.m_flow_nom_turbine_HP_stage1)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Machines.SteamTurbine stage2(
    eta_mech=eta_mech,
    m_flow_start=stage2.m_flow_nominal,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage2,
    T_nominal=nominalData.T_nom_turbine_HP_stage1_drain,
    p_inlet_nominal=nominalData.p_nom_turbine_HP_stage1_drain,
    p_outlet_nominal=nominalData.p_nom_turbine_HP_stage2_drain,
    redeclare model Eta_wetSteam =
        Machines.BaseClasses.WetSteamEfficiency.eta_Constant (eta_nominal=
            eta_is),
    p_a_start=initData.p_start_turbine_HP_stage1_drain,
    p_b_start=initData.p_start_turbine_HP_stage2_drain,
    use_T_start=false,
    h_a_start=stage2.Medium.specificEnthalpy_pTX(
        stage2.p_a_start,
        initData.T_start_turbine_IP_drain,
        stage2.Medium.reference_X),
    h_b_start=stage2.Medium.specificEnthalpy_pTX(
        stage2.p_b_start,
        initData.T_start_turbine_HP_stage1_drain,
        stage2.Medium.reference_X),
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Volumes.MixingVolume                 vol_turbine1(
    nPorts_b=2,
    nPorts_a=1,
    p_start=stage1.p_b_start,
    T_start=initData.T_start_turbine_IP_drain,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{-29,-26},{-17,-14}})));

  Volumes.MixingVolume                 vol_turbine2(
    nPorts_b=1,
    nPorts_a=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    p_start=stage2.p_b_start,
    T_start=initData.T_start_turbine_HP_stage1_drain,
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{24,-26},{36,-14}})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a annotation (
      Placement(transformation(rotation=0, extent={{-128,-10},{-108,10}}),
        iconTransformation(extent={{-128,-10},{-108,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b annotation (
      Placement(transformation(rotation=0, extent={{110,-10},{130,10}}),
        iconTransformation(extent={{110,-10},{130,10}})));
  Interfaces.FluidPort_Flow                   port_a(redeclare package
      Medium =
        Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(rotation=0, extent={{-94,34},
            {-74,54}}),iconTransformation(extent={{-94,34},
            {-74,54}})));
  Interfaces.FluidPort_State drain1(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(rotation=0, extent={{-38,-72},{-16,-52}}),
        iconTransformation(extent={{-36,-72},{-16,-52}})));
  Interfaces.FluidPort_State drain2(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(rotation=0, extent={{54,-98},{74,-78}}),
        iconTransformation(extent={{54,-98},{74,-78}})));
  parameter Records.RankineStartValues initData(
    p_start_turbine_HP_stage1_feed=nominalData.p_nom_turbine_HP_stage1_feed,
    p_start_turbine_HP_stage1_drain=nominalData.p_nom_turbine_HP_stage1_drain,
    p_start_turbine_LP_stage1_drain=nominalData.p_nom_turbine_LP_stage1_drain,
    p_start_turbine_LP_stage2_drain=nominalData.p_nom_turbine_LP_stage2_drain,
    p_start_condenser=nominalData.p_nom_condenser,
    p_start_feedWaterPump_drain=nominalData.p_nom_feedWaterPump_drain,
    p_start_preheater_LP=nominalData.p_nom_preheater_LP,
    p_start_preheater_HP=nominalData.p_nom_preheater_HP,
    T_start_turbine_HP_stage1_feed=nominalData.T_nom_turbine_HP_stage1_feed,
    T_start_turbine_HP_stage1_drain=nominalData.T_nom_turbine_HP_stage1_drain,
    T_start_turbine_IP_drain=nominalData.T_nom_turbine_LP_stage1_drain,
    p_start_dearator=nominalData.p_nom_dearator,
    T_start_turbine_LP_drain=nominalData.T_nom_turbine_LP_stage2_drain,
    p_start_preheater_HP_cooling_in=nominalData.p_nom_preheater_HP_cooling_in,
    p_start_preheater_HP_cooling_out=nominalData.p_nom_preheater_HP_cooling_out,
    T_start_preheater_HP_cooling_out=nominalData.T_nom_preheater_HP_cooling_out,
    p_start_to_SG_drain=nominalData.p_nom_to_SG_drain,
    p_start_turbine_LP_stage1_feed=nominalData.p_nom_turbine_LP_stage1_feed,
    T_start_turbine_LP_feed=nominalData.T_nom_turbine_LP_stage1_feed)
    "Initialization data" annotation (Dialog(group="Initialization"),
      Placement(transformation(extent={{66,74},{86,94}})));

  HeatAndMassTransfer.Resistances.Heat.Convection convection1(surfaceArea=100,
      alpha=5000)
    annotation (Placement(transformation(extent={{-46,-32},{-36,-22}})));
  HeatAndMassTransfer.Volumes.UnitVolume unitVolume1(
    V=1,
    d=1000,
    cp=500,
    T_start=vol_turbine1.T_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-54,-27},{-48,-21}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection2(surfaceArea=100,
      alpha=5000)
    annotation (Placement(transformation(extent={{8,-34},{18,-24}})));
  HeatAndMassTransfer.Volumes.UnitVolume unitVolume2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1,
    d=1000,
    cp=500,
    T_start=vol_turbine2.T_start)
    annotation (Placement(transformation(extent={{0,-29},{6,-23}})));
equation
  connect(stage1.shaft_b, stage2.shaft_a) annotation (Line(
      points={{-30,0},{-4,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(shaft_a, stage1.shaft_a)
    annotation (Line(points={{-118,0},{-50,0}},          color={0,0,0}));
  connect(stage2.shaft_b, shaft_b) annotation (
      Line(points={{16,0},{120,0}},         color=
         {0,0,0}));
  connect(port_a, stage1.portHP) annotation (Line(
      points={{-84,44},{-50,44},{-50,6}},
      color={0,127,255},
      thickness=0.5));

  connect(drain2, vol_turbine2.port_b[1]) annotation (Line(
      points={{64,-88},{64,-20},{33.6,-20}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine2.port_a[1], stage2.portLP) annotation (Line(
      points={{26.4,-20},{13,-20},{13,-10}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine1.port_b[1], stage2.portHP) annotation (Line(
      points={{-19.4,-20.3},{-12,-20.3},{-12,6},{-4,6}},
      color={0,127,255},
      thickness=0.5));
  connect(drain1, vol_turbine1.port_b[2]) annotation (Line(
      points={{-27,-62},{-12,-62},{-12,-19.7},{-19.4,-19.7}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine1.port_a[1], stage1.portLP) annotation (Line(
      points={{-26.6,-20},{-33,-20},{-33,-10}},
      color={0,127,255},
      thickness=0.5));
  connect(convection1.port_b, vol_turbine1.heatPort) annotation (Line(
      points={{-37.5,-27},{-23,-27},{-23,-23.6}},
      color={191,0,0},
      thickness=0.5));
  connect(convection1.port_a, unitVolume1.port) annotation (Line(
      points={{-44.5,-27},{-47.25,-27},{-51,-27}},
      color={191,0,0},
      thickness=0.5));
  connect(unitVolume2.port, convection2.port_a) annotation (Line(
      points={{3,-29},{6.5,-29},{9.5,-29}},
      color={191,0,0},
      thickness=0.5));
  connect(convection2.port_b, vol_turbine2.heatPort) annotation (Line(
      points={{16.5,-29},{30,-29},{30,-23.6}},
      color={191,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-120,10},{-100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),      Rectangle(
          extent={{100,10},{120,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),
        Polygon(
          points={{-100,40},{-100,-40},{100,-100},
              {100,-100},{100,80},{100,100},{-100,
              40}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,20},{82,-6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end HP_turbine;
