within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model LP_turbine
  parameter Real eta_is=0.88 "Turbine isentropic efficiency";
  parameter Real eta_mech=0.998 "Turbine mechanical efficiency";
  replaceable package Medium =
      Modelica.Media.Water.StandardWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter Integer N_drain_stage1r=0 "Number of drain_stage1r ports" annotation(Dialog(connectorSizing=true));
  parameter Integer N_drain_stage2r=0 "Number of drain_stage2r ports" annotation(Dialog(connectorSizing=true));

  parameter Records.RankineNominalValues nominalData "Nominal data"
    annotation (Dialog(group="Nominal operating data"), Placement(
        transformation(extent={{40,73},{60,94}})));

  Machines.SteamTurbineStodola stage1(
    eta_mech=eta_mech,
    redeclare model Eta_wetSteam =
        Machines.BaseClasses.WetSteamEfficiency.eta_Constant (  eta_nominal=
            eta_is),
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage1/2,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T_nominal=nominalData.T_nom_turbine_LP_stage1_feed,
    p_in_nominal=nominalData.p_nom_turbine_LP_stage1_feed,
    p_out_nominal=nominalData.p_nom_turbine_LP_stage1_drain,
    p_a_start=initData.p_start_turbine_LP_stage1_feed,
    p_b_start=initData.p_start_turbine_LP_stage1_drain,
    use_T_start=false,
    h_a_start=stage1.Medium.specificEnthalpy_pTX(
        stage1.p_a_start,
        initData.T_start_turbine_LP_feed,
        stage1.Medium.reference_X),
    h_b_start=stage1.Medium.specificEnthalpy_pTX(
        stage1.p_b_start,
        initData.T_start_turbine_IP_drain,
        stage1.Medium.reference_X))
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Machines.SteamTurbineStodola stage2(
    eta_mech=eta_mech,
    redeclare model Eta_wetSteam =
        Machines.BaseClasses.WetSteamEfficiency.eta_Constant (  eta_nominal=
            eta_is),
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage2/2,
    T_nominal=nominalData.T_nom_turbine_LP_stage1_drain,
    p_in_nominal=nominalData.p_nom_turbine_LP_stage1_drain,
    p_out_nominal=nominalData.p_nom_turbine_LP_stage2_drain,
    p_a_start=initData.p_start_turbine_LP_stage1_drain,
    p_b_start=initData.p_start_turbine_LP_stage2_drain,
    use_T_start=false,
    h_a_start=stage2.Medium.specificEnthalpy_pTX(
        stage2.p_a_start,
        initData.T_start_turbine_IP_drain,
        stage2.Medium.reference_X),
    h_b_start=stage2.Medium.specificEnthalpy_pTX(
        stage2.p_b_start,
        initData.T_start_turbine_LP_drain,
        stage2.Medium.reference_X))
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Machines.SteamTurbineStodola stage3(
    eta_mech=eta_mech,
    redeclare model Eta_wetSteam =
        Machines.BaseClasses.WetSteamEfficiency.eta_Constant (  eta_nominal=
            eta_is),
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage3/2,
    T_nominal=nominalData.T_nom_turbine_LP_stage2_drain,
    p_in_nominal=nominalData.p_nom_turbine_LP_stage2_drain,
    p_out_nominal=nominalData.p_nom_condenser,
    use_T_start=false,
    h_a_start=stage3.Medium.specificEnthalpy_pTX(
        stage3.p_a_start,
        stage3.T_nominal,
        stage3.Medium.reference_X),
    h_b_start=stage3.Medium.specificEnthalpy_pTX(
        stage3.p_b_start,
        273.15 + 25.420,
        stage3.Medium.reference_X),
    p_a_start=stage3.p_in_nominal,
    p_b_start=stage3.p_out_nominal)
    annotation (Placement(transformation(extent={{49,-10},{69,10}})));
  Volumes.MixingVolume                 vol_turbine1(
    nPorts_b=2,
    nPorts_a=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=stage1.p_b_start,
    T_start=initData.T_start_turbine_IP_drain,
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{-29,-26},{-17,-14}})));

  Volumes.MixingVolume                 vol_turbine2(
    nPorts_b=2,
    nPorts_a=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=stage2.p_b_start,
    T_start=initData.T_start_turbine_LP_drain,
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{18,-26},{30,-14}})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a annotation (
      Placement(transformation(rotation=0, extent={{-128,-10},{-108,10}}),
        iconTransformation(extent={{-128,-10},{-108,10}})));
  Interfaces.FluidPort_Flow                 drain(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(rotation=0, extent={{70,-84},
            {90,-64}}), iconTransformation(extent={{70,-84},{90,-64}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b annotation (
      Placement(transformation(rotation=0, extent={{110,-10},{130,10}}),
        iconTransformation(extent={{110,-10},{130,10}})));
  Interfaces.FluidPort_Flow                   port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(rotation=0, extent={{-10,56},
            {10,76}}), iconTransformation(extent={{-10,56},{10,76}})));
  Interfaces.FluidPort_State drain1(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(rotation=0, extent={{4,-58},{26,-38}}),
        iconTransformation(extent={{6,-58},{26,-38}})));
  Interfaces.FluidPort_State drain2(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(rotation=0, extent={{38,-72},{58,-52}}),
        iconTransformation(extent={{38,-72},{58,-52}})));
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

  HeatAndMassTransfer.Volumes.UnitVolume unitVolume1(
    V=1,
    cp=500,
    T_start=vol_turbine1.T_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    d=5000)
    annotation (Placement(transformation(extent={{-52,-29},{-46,-23}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection1(surfaceArea=100,
      alpha=5000)
    annotation (Placement(transformation(extent={{-44,-34},{-34,-24}})));
  HeatAndMassTransfer.Volumes.UnitVolume unitVolume2(
    V=1,
    cp=500,
    T_start=vol_turbine1.T_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    d=5000)
    annotation (Placement(transformation(extent={{-4,-27},{2,-21}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection2(surfaceArea=100,
      alpha=5000)
    annotation (Placement(transformation(extent={{4,-32},{14,-22}})));
equation
  connect(stage1.shaft_b, stage2.shaft_a) annotation (Line(
      points={{-30,0},{-4,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(stage2.shaft_b, stage3.shaft_a) annotation (Line(
      points={{16,0},{49,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(shaft_a, stage1.shaft_a)
    annotation (Line(points={{-118,0},{-50,0}},          color={0,0,0}));
  connect(shaft_b, stage3.shaft_b)
    annotation (Line(points={{120,0},{69,0}}, color={0,0,0}));
  connect(stage1.portHP, port_a) annotation (Line(points={{-50,6},{-50,6},{-50,
          46},{-50,60},{0,60},{0,66}}, color={0,127,255}));
  connect(stage3.portLP, drain)
    annotation (Line(points={{66,-10},{80,-10},{80,-74}}, color={0,127,255}));
  connect(drain1, vol_turbine1.port_b[1]) annotation (Line(
      points={{15,-48},{-12,-48},{-12,-20.3},{-19.4,-20.3}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine1.port_a[1], stage1.portLP) annotation (Line(
      points={{-26.6,-20},{-33,-20},{-33,-10}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine1.port_b[2], stage2.portHP) annotation (Line(
      points={{-19.4,-19.7},{-12,-19.7},{-12,6},{-4,6}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine2.port_b[1], stage3.portHP) annotation (Line(
      points={{27.6,-20.3},{36,-20.3},{36,6},{49,6}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine2.port_a[1], stage2.portLP) annotation (Line(
      points={{20.4,-20},{13,-20},{13,-10}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine2.port_b[2], drain2) annotation (Line(
      points={{27.6,-19.7},{36,-19.7},{36,-62},{48,-62}},
      color={0,127,255},
      thickness=0.5));
  connect(unitVolume1.port, convection1.port_a) annotation (Line(
      points={{-49,-29},{-45.5,-29},{-42.5,-29}},
      color={191,0,0},
      thickness=0.5));
  connect(convection1.port_b, vol_turbine1.heatPort) annotation (Line(
      points={{-35.5,-29},{-23,-29},{-23,-23.6}},
      color={191,0,0},
      thickness=0.5));
  connect(unitVolume2.port, convection2.port_a) annotation (Line(
      points={{-1,-27},{2.5,-27},{5.5,-27}},
      color={191,0,0},
      thickness=0.5));
  connect(convection2.port_b, vol_turbine2.heatPort) annotation (Line(
      points={{12.5,-27},{24,-27},{24,-23.6}},
      color={191,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-2,74},{2,40}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-120,10},{-100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),      Rectangle(
          extent={{100,10},{120,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),
        Polygon(
          points={{-100,80},{-100,-80},{0,-40},{100,-82},{100,80},{0,40},{-100,80}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,0.5},{-40,0.5}},
          color={0,0,0},
          origin={0.5,0},
          rotation=90),
        Text(
          extent={{-100,6},{-2,-4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end LP_turbine;
