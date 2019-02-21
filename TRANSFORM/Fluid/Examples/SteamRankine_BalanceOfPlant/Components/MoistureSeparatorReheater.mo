within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model MoistureSeparatorReheater "Moisture separator reheater"
  import TRANSFORM;
  Interfaces.FluidPort_Flow                 feed(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(extent={{-10,-56},{10,-36}}),
        iconTransformation(extent={{-10,-56},{10,-36}})));
  Interfaces.FluidPort_State drain[N_drain](redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(extent={{-10,30},{10,50}}), iconTransformation(extent={{
            -10,30},{10,50}})));
  Interfaces.FluidPort_State hotFeed(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(extent={{-110,14},{-90,34}}), iconTransformation(extent=
            {{-108,10},{-88,30}})));
  Interfaces.FluidPort_State hotDrain(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(extent={{-110,-30},{-90,-10}}), iconTransformation(
          extent={{-110,-30},{-90,-10}})));
  TRANSFORM.Fluid.Volumes.Separator_2phaseOnly separator(
    eta_sep=0.85,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=4),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_HP_stage2_drain - (initData.p_start_turbine_HP_stage2_drain
         - initData.p_start_turbine_LP_stage1_feed)/3,
    use_T_start=false,
    h_start=2700e3)
    annotation (Placement(transformation(extent={{54,10},{34,30}})));
  FittingsAndResistances.NominalLoss lossMainSteam2(
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage1,
    d_nominal=5,
    dp_nominal=(nominalData.p_nom_turbine_HP_stage2_drain - nominalData.p_nom_turbine_LP_stage1_feed)
        /3,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_nominal=5000000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={16,20})));
  FittingsAndResistances.NominalLoss lossMainSteam1(
    dp_nominal=(nominalData.p_nom_turbine_HP_stage2_drain - nominalData.p_nom_turbine_LP_stage1_feed)
        /3,
    d_nominal=5,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_nominal=500000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={66,20})));
  Volumes.MixingVolume                    mixVolumeMainSteamOutlet(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_LP_stage1_feed,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=4),
    T_start=initData.T_start_turbine_LP_feed,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts_b=N_drain,
    nPorts_a=1)
              annotation (Placement(transformation(extent={{-16,16},{-36,36}})));
  parameter Records.RankineNominalValues nominalData "Nominal data"
    annotation (Dialog(group="Nominal operating data"), Placement(
        transformation(extent={{40,60},{60,80}})));
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
    T_start_turbine_LP_feed=nominalData.T_nom_turbine_LP_stage1_feed,
    p_start_turbine_HP_stage2_feed=nominalData.p_nom_turbine_HP_stage2_feed,
    p_start_turbine_HP_stage2_drain=nominalData.p_nom_turbine_HP_stage2_drain)
    "Initialization data" annotation (Dialog(group="Initialization"),
      Placement(transformation(extent={{67,60},{87,80}})));
  replaceable package Medium =
      Modelica.Media.Water.StandardWater;
 parameter Integer N_drain=0 "Number of drain ports"
    annotation (Dialog(connectorSizing=true));
  Interfaces.FluidPort_Flow                 condensateDrain(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
                       annotation (Placement(transformation(extent={{84,-52},{104,
            -32}}), iconTransformation(extent={{68,-56},{88,-36}})));
  Records.MoistureSeparatorReheaterSummary summary(
    m_flow_main_steam_in=feed.m_flow,
    m_flow_main_condensate_out=-condensateDrain.m_flow,
    m_flow_hot_steam_in=hotFeed.m_flow,
    m_flow_hot_out=-hotDrain.m_flow,
    T_main_steam_in=lossMainSteam1.T,
    m_flow_main_steam_out=-sum(drain.m_flow),
    x_main_steam_out=1,
    T_main_steam_out=mixVolumeMainSteamOutlet.medium.T,
    T_hot_steam_in=lossMainSteam2.T,
    x_main_steam_in=separator.x_abs,
    Q_hex=-hex.heatRes_inner.Q_flows[1],
    T_hot_out=hex.medium.T)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  TRANSFORM.Fluid.Volumes.Condenser hex(
    level_start=1,
    p_start=initData.p_start_preheater_HP + 8e5,
    T_start_wall=Medium.saturationTemperature(hex.p_start) - 3,
    redeclare package Medium_coolant =
        Modelica.Media.Water.StandardWater,
    alphaInt_WExt=3e4,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.Cylinder_wInternalPipe
        (
        orientation="Horizontal",
        length=20,
        r_inner=2,
        nTubes=1800,
        r_tube_inner=0.5*0.016,
        th_tube=0.002),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-34,-20},{-8,7}})));
equation
  connect(mixVolumeMainSteamOutlet.port_b, drain) annotation (Line(
      points={{-32,26},{-42,26},{-42,40},{0,40}},
      color={0,127,255},
      thickness=0.5));
  connect(lossMainSteam1.port_a, feed) annotation (Line(
      points={{73,20},{76,20},{76,-46},{0,-46}},
      color={0,127,255},
      thickness=0.5));
  connect(lossMainSteam2.port_a, separator.port_b[1]) annotation (Line(
      points={{23,20},{30.5,20},{38,20}},
      color={0,127,255},
      thickness=0.5));
  connect(separator.port_a[1], lossMainSteam1.port_b) annotation (Line(
      points={{50,20},{59,20}},
      color={0,127,255},
      thickness=0.5));
  connect(separator.port_Liquid, condensateDrain) annotation (Line(
      points={{48,16},{48,-42},{94,-42}},
      color={0,127,255},
      thickness=0.5));
  connect(hex.portCoolant_b, mixVolumeMainSteamOutlet.port_a[1]) annotation (
      Line(
      points={{-6.7,-9.2},{0,-9.2},{0,26},{-20,26}},
      color={0,127,255},
      thickness=0.5));
  connect(lossMainSteam2.port_b, hex.portCoolant_a) annotation (Line(
      points={{9,20},{4,20},{4,-1.1},{-6.7,-1.1}},
      color={0,127,255},
      thickness=0.5));
  connect(hex.portFluidDrain, hotDrain) annotation (Line(
      points={{-21,-17.03},{-21,-20},{-100,-20}},
      color={0,127,255},
      thickness=0.5));
  connect(hex.portSteamFeed, hotFeed) annotation (Line(
      points={{-30.1,2.95},{-30.1,8},{-82,8},{-82,24},{-100,24}},
      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                         Rectangle(
          extent={{-90,40},{90,-46}},
          lineColor={95,95,95},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
                               Text(extent={{-100,-11},{100,8}},textString=
          "%name",
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          fontSize=0),
        Polygon(
          points={{-90,40},{-100,36},{-100,-42},{-90,-46},{-90,40}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{5,43},{-5,39},{-5,-39},{5,-43},{5,43}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={95,-3},
          rotation=180)}),
                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end MoistureSeparatorReheater;
