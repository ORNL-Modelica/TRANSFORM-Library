within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model Rankine "Rankine cycle model"
  import TRANSFORM;

  extends
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialRankine;
  Real dearator_level_percentage=dearator.geometry.level_meas_percentage;
//100*(dearator.summary.level_meas-dearator.summary.level_meas_min)/(dearator.summary.level_max-dearator.summary.level_meas_min) "Dearator level percentage";
  Real preheater_LP_level_percentage=FWH_LP.geometry.level_meas_percentage;
//   100*(FWH_LP.level_meas - FWH_LP.level_meas_min)/(
//       FWH_LP.level_meas_max - FWH_LP.level_meas_min) "Preheater LP level percentage";
  Real preheater_HP_level_percentage=FWH_HP.geometry.level_meas_percentage;
//100*(FWH_HP.level_meas - FWH_HP.level_meas_min)/(
//      FWH_HP.level_meas_max - FWH_HP.level_meas_min) "Preheater HP level percentage";
  Real condenser_level_percentage=condenser.geometry.level_meas_percentage;
//100*(condenser.level_meas-condenser.level_meas_min)/(condenser.level_meas_max-condenser.level_meas_min) "Condenser level percentage";
  Real MSR_level_percentage=MSR.hex.geometry.level_meas_percentage;
//100*(MSR.hex.level_meas-MSR.hex.level_meas_min)/(MSR.hex.level_meas_max-MSR.hex.level_meas_min) "MSR level percentage";

  Modelica.SIunits.Time tau_condenser=((1 - condenser.mediaProps.x_abs)*
      condenser.m)/max(condenser.portSteamFeed.m_flow, 1)
    "Condenser hold up time";
  Modelica.SIunits.Time tau_FWH_LP=((1 - FWH_LP.mediaProps.x_abs)*FWH_LP.m)/max(
       FWH_LP.portSteamFeed.m_flow, 1) "FWH_LP hold up time";
  Modelica.SIunits.Time tau_FWH_HP=((1 - FWH_HP.mediaProps.x_abs)*FWH_HP.m)/max(
       FWH_HP.portSteamFeed.m_flow, 1) "FWH_HP hold up time";
  Modelica.SIunits.Time tau_Dearator=((1 - dearator.mediaProps.x_abs)*dearator.m)
      /max(dearator.summary.m_flow_out_condensate, 1) "Dearator hold up time";
  Modelica.SIunits.Time tau_MSR=((1 - MSR.hex.mediaProps.x_abs)*MSR.hex.m)/max(
      MSR.hex.portSteamFeed.m_flow, 1) "MSR hold up time";

  Electrical.PowerConverters.Generator_Basic generator(efficiency=0.98)
    annotation (Placement(transformation(extent={{130,41},{150,61}})));

  TRANSFORM.Fluid.Volumes.Condenser condenser(
    p_start=initData.p_start_condenser,
    level_start=0.6,
    alphaInt_WExt=1e5,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.Cylinder_wInternalPipe
        (
        orientation="Horizontal",
        length=20,
        r_inner=1.5,
        nTubes=20e3,
        r_tube_inner=0.5*0.016,
        th_tube=0.002),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{165,-3},{185,17}})));

  Pump CondPump_2(
    W_curve={1,1,1},
    checkValve=true,
    N_nominal=1200,
    V=0.5,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(CondPump_2.p_a_start)),
    V_flow_curve=(CondPump_2.m_flow_start/CondPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/CondPump_2.d_nominal)*(nominalData.p_nom_dearator -
        nominalData.p_nom_condenser)*{2,1,0},
    p_a_start=initData.p_start_condenser,
    p_b_start=initData.p_start_dearator,
    m_flow_start=nominalData.m_flow_nom_turbine_LP_stage3/nbr_pumps_LP,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=CondPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{164,-54},{150,-40}})));
  Volumes.Deaerator dearator(
    p_start=initData.p_start_dearator,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder
        (
        orientation="Horizontal",
        length=15,
        r_inner=5,
        th_wall=0.2),
    d_wall=8000,
    cp_wall=500,
    alpha_external=20,
    alpha_internal=5000,
    Twall_start=433.15)
    annotation (Placement(transformation(extent={{53,-53},{30,-36}})));

  Pump pump_ip(
    W_curve={1,1,1},
    checkValve=true,
    N_nominal=1200,
    V=0.1,
    p_a_start=initData.p_start_preheater_LP,
    p_b_start=initData.p_start_dearator,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_preheater_LP)),
    m_flow_start=nominalData.m_flow_nom_turbine_LP_stage2 - nominalData.m_flow_nom_turbine_LP_stage3,
    head_curve=(1/10*1/pump_ip.d_nominal)*(nominalData.p_nom_dearator -
        nominalData.p_nom_preheater_LP)*{2,1,0},
    V_flow_curve=(pump_ip.m_flow_start/pump_ip.d_nominal)*{0,1,2},
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8),
    m_flow_nominal=pump_ip.m_flow_start)
    annotation (Placement(transformation(extent={{79,-96},{65,-82}})));

  Pump FWPump_2(
    W_curve={1,1,1},
    checkValve=true,
    V=0.4,
    N_nominal=1165,
    p_a_start=dearator.p_start + 1e5,
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(dearator.p_start)) - 5000,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_dearator)),
    V_flow_curve=(FWPump_2.m_flow_start/FWPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/FWPump_2.d_nominal)*(nominalData.p_nom_preheater_HP_cooling_in
         - nominalData.p_nom_dearator)*{2,1,0},
    m_flow_start=nominalData.m_flow_nom_feedWaterPump,
    p_b_start=initData.p_start_preheater_HP_cooling_in,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal=FWPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{29,-104},{15,-90}})));

  FittingsAndResistances.ElevationChange heightDiff(redeclare package
      Medium =
        Medium, dheight=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={174,-17})));

  FittingsAndResistances.ElevationChange heightDiff1(redeclare package
      Medium =
        Medium, dheight=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={104,-69})));
  FittingsAndResistances.ElevationChange heightDiff2(redeclare package
      Medium =
        Modelica.Media.Water.StandardWater, dheight=-1) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={43,-75})));
  Volumes.MixingVolume vol_feedWaterPump(
    nPorts_b=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_preheater_HP_cooling_in,
    use_T_start=false,
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(dearator.p_start)),
    redeclare package Medium = Medium,
    nPorts_a=3,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3))
                annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-25,-85})));

  FittingsAndResistances.ElevationChange heightDiff3(redeclare package
      Medium =
        Medium, dheight=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-53,-63})));
  Modelica.Blocks.Sources.RealExpression gen_power(y=
        generator.power)
    annotation (Placement(transformation(extent={{202,-134},{187,-121}})));
  Valves.ValveCompressible valve_preheater_hp(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_HP_stage1_drain - nominalData.p_nom_preheater_HP,
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1 - nominalData.m_flow_nom_turbine_HP_stage2,
    p_nominal=HPT.stage1.p_outlet_nominal,
    checkValve=true,
    rho_nominal=valve_preheater_hp.Medium.density_pTX(
        valve_preheater_hp.p_nominal,
        782.502,
        valve_preheater_hp.Medium.X_default)) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-52,15})));

  Valves.ValveIncompressible               valve_FWH_HP_control(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP - nominalData.p_nom_dearator),
    m_flow_nominal=(nominalData.m_flow_nom_turbine_HP_stage1 - nominalData.m_flow_nom_turbine_HP_stage2)
        *2,
    rho_nominal=1000)
                  annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-1,-34})));

  Volumes.MixingVolume                    vol_preheater_HP(
    redeclare package Medium = Medium,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_preheater_HP_cooling_out,
    T_start=initData.T_start_preheater_HP_cooling_out,
    nPorts_b=6,
    nPorts_a=1)    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-71,-80})));
  Valves.ValveIncompressible loss_preheater_HP(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_in - nominalData.p_nom_preheater_HP_cooling_out),
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump,
    rho_nominal=FWPump_2.d_nominal) annotation (Placement(transformation(
        extent={{5.5,-6},{-5.5,6}},
        rotation=270,
        origin={-33,-63.5})));

  Records.RankineSummary summary(
    p_condenser=condenser.medium.p,
    p_feedWaterPump_drain=drain_to_SG1.p,
    p_preheater_LP=FWH_LP.medium.p,
    p_preheater_HP=FWH_HP.medium.p,
    p_preheater_HP_cooling_in=FWH_HP.portCoolant_a.p,
    p_preheater_HP_cooling_out=FWH_HP.portCoolant_b.p,
    p_turbine_LP_feed=LPT_1.stage1.p_out,
    level_preheater_LP=FWH_LP.level,
    level_dearator=dearator.level,
    level_preheater_HP=FWH_HP.level,
    level_condenser=condenser.level,
    T_preheater_HP_cooling_out=vol_preheater_HP.medium.T,
    m_flow_feedWaterPump=-drain_to_SG1.m_flow,
    T_condenser=condenser.medium.T,
    power_generator=generator.power,
    power_pump_lp=CondPump_2.W_total,
    power_pump_ip=pump_ip.W_total,
    power_pump_hp=FWPump_2.W_total,
    T_condenser_cooling_in=293.15,
    T_condenser_cooling_out=293.15,
    Q_preheater_LP=FWH_HP.heatRes_inner.Q_flows[1],
    Q_preheater_HP=FWH_LP.heatRes_inner.Q_flows[1],
    Q_condenser=condenser.heatRes_inner.Q_flows[1],
    p_dearator=dearator.summary.p,
    u_pump_lp=CondPump_2.N_input,
    u_pump_ip=pump_ip.N_input,
    u_pump_hp=FWPump_2.N_input,
    p_turbine_LP_drain=LPT_1.drain.p,
    T_turbine_LP_feed=MSR.summary.T_main_steam_out,
    m_flow_turbine_LP_feed=LPT_1.port_a.m_flow + LPT_2.port_a.m_flow,
    m_flow_turbine_LP_drain=-(LPT_1.drain.m_flow + LPT_2.drain.m_flow),
    p_turbine_HP_stage1_feed=HPT.stage1.portHP.p,
    p_turbine_HP_stage1_drain=HPT.stage1.portLP.p,
    m_flow_turbine_HP=HPT.stage1.m_flow,
    T_turbine_HP_stage1_drain=HPT.vol_turbine1.medium.T,
    T_turbine_HP_stage1_feed=header.medium.T,
    u_valve_preheat_hp=valve_FWH_HP_control.opening,
    T_turbine_LP_drain=condenser.medium.T)
    annotation (Placement(transformation(extent={{231,48},{251,68}})));

  LP_turbine                                                         LPT_1(
    eta_is=eta_is_LPT,
    eta_mech=eta_mech,
    redeclare package Medium = Medium,
    nominalData=nominalData,
    initData=initData,
    N_drain_stage2r=1) annotation (Placement(transformation(rotation=0, extent={
            {15,38},{40,63}})));

  Pump CondPump_1(
    W_curve={1,1,1},
    checkValve=true,
    N_nominal=1200,
    V=0.5,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(CondPump_2.p_a_start)),
    V_flow_curve=(CondPump_2.m_flow_start/CondPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/CondPump_2.d_nominal)*(nominalData.p_nom_dearator -
        nominalData.p_nom_condenser)*{2,1,0},
    p_a_start=initData.p_start_condenser,
    p_b_start=initData.p_start_dearator,
    m_flow_start=nominalData.m_flow_nom_turbine_LP_stage3/nbr_pumps_LP,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=CondPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{163,-38},{149,-24}})));
  Pump CondPump_3(
    W_curve={1,1,1},
    checkValve=true,
    N_nominal=1200,
    V=0.5,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(CondPump_2.p_a_start)),
    V_flow_curve=(CondPump_2.m_flow_start/CondPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/CondPump_2.d_nominal)*(nominalData.p_nom_dearator -
        nominalData.p_nom_condenser)*{2,1,0},
    p_a_start=initData.p_start_condenser,
    p_b_start=initData.p_start_dearator,
    m_flow_start=nominalData.m_flow_nom_turbine_LP_stage3/nbr_pumps_LP,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=CondPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{165,-70},{151,-56}})));
  Pump FWPump_1(
    W_curve={1,1,1},
    checkValve=true,
    V=0.4,
    N_nominal=1165,
    p_a_start=dearator.p_start + 1e5,
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(dearator.p_start)) - 5000,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_dearator)),
    V_flow_curve=(FWPump_2.m_flow_start/FWPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/FWPump_2.d_nominal)*(nominalData.p_nom_preheater_HP_cooling_in
         - nominalData.p_nom_dearator)*{2,1,0},
    m_flow_start=nominalData.m_flow_nom_feedWaterPump/nbr_pumps_HP,
    p_b_start=initData.p_start_preheater_HP_cooling_in,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal=FWPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{30,-82},{16,-68}})));

  Pump FWPump_3(
    W_curve={1,1,1},
    checkValve=true,
    V=0.4,
    N_nominal=1165,
    p_a_start=dearator.p_start + 1e5,
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(dearator.p_start)) - 5000,
    d_nominal=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_dearator)),
    V_flow_curve=(FWPump_2.m_flow_start/FWPump_2.d_nominal)*{0,1,2},
    head_curve=(1/10*1/FWPump_2.d_nominal)*(nominalData.p_nom_preheater_HP_cooling_in
         - nominalData.p_nom_dearator)*{2,1,0},
    m_flow_start=nominalData.m_flow_nom_feedWaterPump,
    p_b_start=initData.p_start_preheater_HP_cooling_in,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_N_input=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal=FWPump_2.m_flow_start,
    redeclare model EfficiencyChar =
        ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant (
          eta_constant=0.8))
    annotation (Placement(transformation(extent={{30,-126},{16,-112}})));

  LP_turbine                                                         LPT_2(
    eta_is=eta_is_LPT,
    eta_mech=eta_mech,
    redeclare package Medium = Medium,
    nominalData=nominalData,
    initData=initData,
    N_drain_stage2r=1,
    N_drain_stage1r=1) annotation (Placement(transformation(rotation=0, extent={
            {88,39},{112,63}})));
  Modelica.Blocks.Sources.RealExpression level_condenser(y=
        condenser_level_percentage)
    annotation (Placement(transformation(extent={{202,-122},{187,-109}})));
  Modelica.Blocks.Sources.RealExpression level_preheater_LP(y=
        preheater_LP_level_percentage)
    annotation (Placement(transformation(extent={{202,-110},{187,-97}})));
  Modelica.Blocks.Sources.RealExpression level_preheater_HP(y=
        preheater_HP_level_percentage)
    annotation (Placement(transformation(extent={{202,-98},{187,-85}})));

  Valves.ValveIncompressible               FWIsolationValve_1(
    redeclare package Medium = Medium,
    dp_nominal=0.5*(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain),
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWIsolationValve_1.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        FWIsolationValve_1.Medium.X_default))
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-142,-30})));

  Valves.ValveIncompressible               FWIsolationValve_2(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain),
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWIsolationValve_2.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWIsolationValve_2.Medium.X_default))             annotation (Placement(
        transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-142,-81})));

  Valves.ValveIncompressible               FWIsolationValve_3(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain),
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWIsolationValve_2.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWIsolationValve_2.Medium.X_default))             annotation (Placement(
        transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-143,-130})));

  Volumes.MixingVolume                    vol2_drain_to_SG1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_preheater_HP_cooling_out - 0.5*(initData.p_start_preheater_HP_cooling_out
         - initData.p_start_to_SG_drain),
    T_start=initData.T_start_preheater_HP_cooling_out,
    nPorts_b=1,
    nPorts_a=2,
        redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3))                           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-124,-30})));

  Volumes.MixingVolume                    vol2_drain_to_SG2(
    nPorts_b=1,
    p_start=initData.p_start_preheater_HP_cooling_out - 0.5*(initData.p_start_preheater_HP_cooling_out
         - initData.p_start_to_SG_drain),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=initData.T_start_preheater_HP_cooling_out,
        redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3),
    redeclare package Medium = Medium,
    nPorts_a=2)                           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-124,-81})));

  Volumes.MixingVolume                    vol2_drain_to_SG3(
    redeclare package Medium = Medium,
    p_start=initData.p_start_preheater_HP_cooling_out - 0.5*(initData.p_start_preheater_HP_cooling_out
         - initData.p_start_to_SG_drain),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=initData.T_start_preheater_HP_cooling_out,
    nPorts_b=1,
    nPorts_a=2,
        redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3))                           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-124,-130})));

  Valves.ValveIncompressible               FWControlValve_1(
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWControlValve_1.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWControlValve_1.Medium.X_default),
    redeclare package Medium = Medium)
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-30})));

  Valves.ValveIncompressible               FWControlValve_2(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWControlValve_2.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWControlValve_2.Medium.X_default))
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-81})));

  Valves.ValveIncompressible               FWControlValve_3(
    redeclare package Medium = Medium,
    rho_nominal=FWControlValve_3.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWControlValve_3.Medium.X_default),
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3)
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-130})));

  Valves.ValveIncompressible               FWBypassValve_1(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWBypassValve_1.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWBypassValve_1.Medium.X_default))
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-53})));

  Valves.ValveIncompressible               FWBypassValve_2(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWBypassValve_2.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWBypassValve_2.Medium.X_default))
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-105})));

  Valves.ValveIncompressible               FWBypassValve_3(
    redeclare package Medium = Medium,
    dp_nominal=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    rho_nominal=FWBypassValve_3.Medium.density_pTX(
        nominalData.p_nom_preheater_HP_cooling_out,
        nominalData.T_nom_preheater_HP_cooling_out - 5,
        FWBypassValve_3.Medium.X_default))
            annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-103,-152})));

  Valves.ValveIncompressible FWBlockValve_1(
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    redeclare package Medium = Medium,
    dp_nominal=100000,
    rho_nominal=FWPump_2.d_nominal) annotation (Placement(transformation(
        extent={{5.75,-5.75},{-5.75,5.75}},
        rotation=0,
        origin={-5.75,-70.25})));
  Valves.ValveIncompressible FWBlockValve_2(
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    redeclare package Medium = Medium,
    dp_nominal=100000,
    rho_nominal=FWPump_2.d_nominal) annotation (Placement(transformation(
        extent={{5.75,-5.75},{-5.75,5.75}},
        rotation=0,
        origin={-5.75,-91.25})));
  Valves.ValveIncompressible FWBlockValve_3(
    redeclare package Medium = Medium,
    m_flow_nominal=nominalData.m_flow_nom_feedWaterPump/3,
    dp_nominal=100000,
    rho_nominal=FWPump_2.d_nominal) annotation (Placement(transformation(
        extent={{5.75,-5.75},{-5.75,5.75}},
        rotation=0,
        origin={-5.75,-115.25})));
  Modelica.Blocks.Sources.RealExpression flow_to_SG_1(y=-
        drain_to_SG1.m_flow)
    annotation (Placement(transformation(extent={{202,-146},{187,-133}})));
  Volumes.MixingVolume                    header(
    nPorts_a=3,
    nPorts_b=4,
    p_start=initData.p_start_turbine_HP_stage1_feed,
    T_start=initData.T_start_turbine_HP_stage1_feed + 5,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20))
    annotation (Placement(transformation(extent={{-151,59},{-139,71}})));

  Valves.ValveCompressible                TBypassValve_2(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_HP_stage1_feed - nominalData.p_nom_condenser,
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1*0.6,
    p_nominal=nominalData.p_nom_turbine_HP_stage1_feed,
    rho_nominal=TBypassValve_2.Medium.density_pTX(
        TBypassValve_2.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        TBypassValve_2.Medium.X_default))         annotation (Placement(
        transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-59,90})));

  Valves.ValveCompressible                TBypassValve_1(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_HP_stage1_feed - nominalData.p_nom_condenser,
    p_nominal=nominalData.p_nom_turbine_HP_stage1_feed,
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1*0.6,
    rho_nominal=TBypassValve_1.Medium.density_pTX(
        TBypassValve_1.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        TBypassValve_1.Medium.X_default))         annotation (Placement(
        transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-59,105})));

  Valves.ValveCompressible                TStopValve(
    redeclare package Medium = Medium,
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1,
    rho_nominal=TStopValve.Medium.density_pTX(
        TStopValve.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        TStopValve.Medium.X_default),
    p_nominal=nominalData.p_nom_turbine_HP_stage1_feed,
    dp_nominal=10000)
                   annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-126,65})));

  Volumes.MixingVolume                    vol2_turbine_HP_feed(
    nPorts_a=1,
    redeclare package Medium = Medium,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_HP_stage1_feed - 0.1e5,
    T_start=initData.T_start_turbine_HP_stage1_feed + 5,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-117,59},{-105,71}})));

  Valves.ValveCompressible                TControlValve(
    redeclare package Medium = Medium,
    m_flow_nominal=nominalData.m_flow_nom_turbine_HP_stage1,
    p_nominal=nominalData.p_nom_turbine_HP_stage1_feed,
    dp_nominal=100000,
    rho_nominal=TControlValve.Medium.density_pTX(
        TControlValve.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        TControlValve.Medium.X_default))
                   annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-95,65})));

  Volumes.MixingVolume                    vol3_turbine_HP_feed(
    nPorts_a=1,
    redeclare package Medium = Medium,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_HP_stage1_feed - 2e5,
    T_start=initData.T_start_turbine_HP_stage1_feed + 5,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-79,59},
            {-67,71}})));

  Modelica.Blocks.Sources.RealExpression flow_to_SG_2(y=-
        drain_to_SG2.m_flow)
    annotation (Placement(transformation(extent={{222,-135},{207,-122}})));
  Modelica.Blocks.Sources.RealExpression flow_to_SG_3(y=-
        drain_to_SG3.m_flow)
    annotation (Placement(transformation(extent={{222,-146},{207,-133}})));
  Modelica.Blocks.Sources.RealExpression flow_to_FWH_HW(y=FWH_HP.portCoolant_a.m_flow)
    annotation (Placement(transformation(extent={{222,-122},{207,-109}})));
  Modelica.Blocks.Sources.RealExpression pressure_steamHeader(y=
        header.medium.p)
    annotation (Placement(transformation(extent={{221,-108},{206,-95}})));
  Modelica.Blocks.Sources.RealExpression flow_to_condenser(y=condenser.portSteamFeed.m_flow)
    annotation (Placement(transformation(extent={{241,-135},{226,-122}})));
  Modelica.Blocks.Sources.RealExpression flow_from_condenser(y=condenser.portFluidDrain.m_flow)
    annotation (Placement(transformation(extent={{242,-147},{227,-134}})));
  Modelica.Blocks.Sources.RealExpression flow_from_FWH_LP(y=FWH_LP.portFluidDrain.m_flow)
    annotation (Placement(transformation(extent={{241,-122},{226,-109}})));
  Modelica.Blocks.Sources.RealExpression flow_to_FWH_LP(y=FWH_LP.portSteamFeed.m_flow)
    annotation (Placement(transformation(extent={{241,-109},{226,-96}})));
  Modelica.Blocks.Sources.RealExpression flow_from_FWH_HP(y=FWH_HP.portFluidDrain.m_flow)
    annotation (Placement(transformation(extent={{241,-96},{226,-83}})));
  Modelica.Blocks.Sources.RealExpression flow_to_FWH_HP(y=FWH_HP.portCoolant_a.m_flow)
    annotation (Placement(transformation(extent={{240,-83},{225,-70}})));
  Modelica.Blocks.Sources.RealExpression dp_condenser_pump(y=CondPump_1.dp)
    annotation (Placement(transformation(extent={{262,-147},{247,-134}})));
  Modelica.Blocks.Sources.RealExpression dp_FWH_LP_pump(y=pump_ip.dp)
    annotation (Placement(transformation(extent={{262,-135},{247,-122}})));
  Modelica.Blocks.Sources.RealExpression dp_FWH_HP_valve(y=
        valve_FWH_HP_control.dp)
    annotation (Placement(transformation(extent={{262,-121},{247,-108}})));
  Modelica.Blocks.Sources.RealExpression dp_FWControlValve_1(y=
        FWControlValve_1.dp)
    annotation (Placement(transformation(extent={{262,-107},{247,-94}})));
  Modelica.Blocks.Sources.RealExpression dp_FWControlValve_2(y=
        FWControlValve_2.dp)
    annotation (Placement(transformation(extent={{262,-93},{247,-80}})));
  Modelica.Blocks.Sources.RealExpression dp_FWControlValve_3(y=
        FWControlValve_3.dp)
    annotation (Placement(transformation(extent={{262,-80},{247,-67}})));
  MoistureSeparatorReheater
    MSR(
    nominalData=nominalData,
    initData=initData,
    N_drain=2) annotation (Placement(transformation(extent={{-17,58},{13,88}})));

  HP_turbine                                                         HPT(
    redeclare package Medium = Medium,
    nominalData=nominalData,
    initData=initData,
    eta_is=eta_is_HPT,
    N_drain_stage1r=1,
    N_drain_stage2r=1)
    annotation (Placement(transformation(extent={{-60,41},{-40,61}})));
  Valves.ValveCompressible                ValvMSR(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_HP_stage1_feed - nominalData.p_nom_preheater_HP,
    m_flow_nominal=70,
    rho_nominal=ValvMSR.Medium.density_pTX(
        ValvMSR.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_feed + 10,
        ValvMSR.Medium.X_default),
    p_nominal=7000000)
                   annotation (Placement(transformation(
        extent={{6.5,6.5},{-6.5,-6.5}},
        rotation=180,
        origin={-59.5,76.5})));

  Modelica.Blocks.Sources.RealExpression level_MSR(y=
        MSR_level_percentage)
    annotation (Placement(transformation(extent={{202,-86},{187,-73}})));
  Modelica.Blocks.Sources.RealExpression flow_from_MSR(y=MSR.hex.portFluidDrain.m_flow)
    annotation (Placement(transformation(extent={{240,-70},{225,-57}})));
  Modelica.Blocks.Sources.RealExpression flow_to_MSR(y=MSR.hex.portSteamFeed.m_flow)
    annotation (Placement(transformation(extent={{240,-57},{225,-44}})));
  Modelica.Blocks.Sources.RealExpression dp_MSRLevelControlValve(y=
        valve_msr_preheater_hp.dp)
    annotation (Placement(transformation(extent={{262,-67},{247,-54}})));
  Valves.ValveCompressible                TValve_LPT1(
    redeclare package Medium = Medium,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage1,
    p_nominal=nominalData.p_nom_turbine_LP_stage1_feed,
    dp_nominal=10000,
    rho_nominal=TValve_LPT1.Medium.density_pTX(
        TValve_LPT1.p_nominal,
        nominalData.T_nom_turbine_LP_stage1_feed,
        TValve_LPT1.Medium.X_default))
                  annotation (Placement(transformation(
        extent={{-5.5,-5.5},{5.5,5.5}},
        rotation=270,
        origin={27.5,76.5})));

  Volumes.MixingVolume                    vol_turbine_LPT_1_feed(
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_LP_stage1_feed,
    T_start=initData.T_start_turbine_LP_feed)            annotation (Placement(
        transformation(
        extent={{-4,-4.5},{4,4.5}},
        rotation=270,
        origin={27.5,65})));

  Volumes.MixingVolume                    vol_turbine_LPT_1_feed1(
    redeclare package Medium = Medium,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_turbine_LP_stage1_feed,
    T_start=initData.T_start_turbine_LP_feed,
    nPorts_b=1,
    nPorts_a=1)                                          annotation (Placement(
        transformation(
        extent={{-4,-4.5},{4,4.5}},
        rotation=270,
        origin={100,65})));

  Valves.ValveCompressible                TValve_LPT2(
    redeclare package Medium = Medium,
    m_flow_nominal=nominalData.m_flow_nom_turbine_LP_stage1,
    p_nominal=nominalData.p_nom_turbine_LP_stage1_feed,
    dp_nominal=10000,
    rho_nominal=TValve_LPT2.Medium.density_pTX(
        TValve_LPT2.p_nominal,
        nominalData.T_nom_turbine_LP_stage1_feed,
        TValve_LPT2.Medium.X_default))
                  annotation (Placement(transformation(
        extent={{-5.5,5.5},{5.5,-5.5}},
        rotation=270,
        origin={100,76.5})));

  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-17,-68},{-25,-60}})));
  Valves.ValveCompressible valve_reheater_lp1(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_LP_stage2_drain - nominalData.p_nom_preheater_LP,
    m_flow_nominal=(nominalData.m_flow_nom_turbine_LP_stage2 - nominalData.m_flow_nom_turbine_LP_stage3)
        *0.5,
    checkValve=true,
    rho_nominal=valve_reheater_lp1.Medium.density_pTX(
        valve_reheater_lp1.p_nominal,
        LPT_1.stage2.T_nominal,
        valve_reheater_lp1.Medium.X_default),
    p_nominal=LPT_1.stage2.p_outlet_nominal) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={110,17})));

  Valves.ValveCompressible valve_msr_preheater_hp(
    redeclare package Medium = Medium,
    m_flow_nominal=200,
    p_nominal=HPT.stage1.p_outlet_nominal,
    rho_nominal=valve_msr_preheater_hp.Medium.density_pTX(
        valve_msr_preheater_hp.p_nominal,
        509.352,
        valve_dearator.Medium.X_default),
    dp_nominal=300000,
    checkValve=true) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-17,16})));
  Valves.ValveCompressible valve_dearator(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_LP_stage1_drain - nominalData.p_nom_dearator,
    m_flow_nominal=(nominalData.m_flow_nom_turbine_LP_stage1 - nominalData.m_flow_nom_turbine_LP_stage2)
        *0.5,
    rho_nominal=valve_dearator.Medium.density_pTX(
        valve_dearator.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_drain,
        valve_dearator.Medium.X_default),
    checkValve=true,
    p_nominal=LPT_1.stage1.p_outlet_nominal) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={30,16})));

  Valves.ValveCompressible valve_dearator1(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_LP_stage1_drain - nominalData.p_nom_dearator,
    m_flow_nominal=(nominalData.m_flow_nom_turbine_LP_stage1 - nominalData.m_flow_nom_turbine_LP_stage2)
        *0.5,
    checkValve=true,
    rho_nominal=valve_dearator1.Medium.density_pTX(
        valve_dearator1.p_nominal,
        nominalData.T_nom_turbine_HP_stage1_drain,
        valve_dearator1.Medium.X_default),
    p_nominal=LPT_1.stage1.p_outlet_nominal) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={45,16})));

  Valves.ValveCompressible valve_reheater_lp(
    redeclare package Medium = Medium,
    dp_nominal=nominalData.p_nom_turbine_LP_stage2_drain - nominalData.p_nom_preheater_LP,
    m_flow_nominal=(nominalData.m_flow_nom_turbine_LP_stage2 - nominalData.m_flow_nom_turbine_LP_stage3)
        *0.5,
    checkValve=true,
    rho_nominal=valve_reheater_lp.Medium.density_pTX(
        valve_reheater_lp.p_nominal,
        LPT_1.stage2.T_nominal,
        valve_reheater_lp.Medium.X_default),
    p_nominal=LPT_1.stage2.p_outlet_nominal) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={95,17})));

  TRANSFORM.Fluid.Volumes.Condenser FWH_HP(
    p_start=initData.p_start_preheater_HP,
    T_start_wall=Medium.saturationTemperature(FWH_HP.p_start),
    level_start=1.2,
    redeclare package Medium_coolant = Medium,
    alphaInt_WExt=300000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    energyDynamicsWall=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.Cylinder_wInternalPipe
        (
        orientation="Horizontal",
        length=6,
        r_inner=2,
        nTubes=1800,
        r_tube_inner=0.5*0.016,
        th_tube=0.002),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-63,-44},{-43,-24}})));

  TRANSFORM.Fluid.Volumes.Condenser FWH_LP(
    p_start=initData.p_start_preheater_LP,
    level_start=1.2,
    redeclare package Medium_coolant = Medium,
    alphaInt_WExt=200000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    energyDynamicsWall=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.Cylinder_wInternalPipe
        (
        orientation="Horizontal",
        length=6,
        r_inner=2,
        nTubes=1800,
        r_tube_inner=0.5*0.016,
        th_tube=0.002),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{94,-52},{114,-32}})));

  BoundaryConditions.Boundary_pT cooling_sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(extent={{231,-15},{211,5}})));
  BoundaryConditions.MassFlowSource_T cooling_source(
    m_flow=250000*0.00006309*1000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{233,13},{213,33}})));
equation

  connect(pump_ip.N_input, controlBus.u_pumpspeed_IP) annotation (Line(
      points={{72,-82},{80,-82},{80,-83},{85,-83},{85,-140},{37.1,-140},{37.1,-139.9}},
      color={255,219,11},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));

  connect(CondPump_2.N_input, controlBus.u_pumpspeed_LP[2]) annotation (Line(
      points={{157,-40},{173,-40},{173,-41},{178,-41},{178,-140},{37,-140},{37,
          -139.9},{37.1,-139.9}},
      color={255,219,11},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));

  connect(controlBus.y_Generator_Power, gen_power.y) annotation (Line(
      points={{37.1,-139.9},{64,-139.9},{64,-140},{183,-140},{183,-128},{185,-128},
          {185,-127.5},{186.25,-127.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.u_pumpspeed_LP[1], CondPump_1.N_input) annotation (Line(
      points={{37.1,-139.9},{64,-139.9},{64,-140},{178,-140},{178,-25},{157,-25},
          {156,-24}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.u_pumpspeed_LP[3], CondPump_3.N_input) annotation (Line(
      points={{37.1,-139.9},{56,-139.9},{56,-140},{178,-140},{178,-69},{178,-58},
          {170,-58},{170,-56},{158,-56}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.u_pumpspeed_HP[1], FWPump_1.N_input) annotation (Line(
      points={{37.1,-139.9},{36,-139.9},{36,-69},{31,-69},{31,-68},{23,-68}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.u_pumpspeed_HP[2], FWPump_2.N_input) annotation (Line(
      points={{37.1,-139.9},{36,-139.9},{36,-90},{22,-90}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.u_pumpspeed_HP[3], FWPump_3.N_input) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{36,-139.9},{36,-112},{23,-112}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));

  connect(LPT_2.shaft_a, LPT_1.shaft_b) annotation (Line(points={{85.84,51},{42.5,
          51},{42.5,50.5}}, color={0,0,0}));
  connect(LPT_2.shaft_b, generator.shaft)
    annotation (Line(points={{114.4,51},{122,51},{122,51.3},{130.3,51.3}},
                                                   color={0,0,0}));
  connect(controlBus.y_Condenser_level, level_condenser.y) annotation (Line(
      points={{37.1,-139.9},{183,-139.9},{183,-115.5},{186.25,-115.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_LP_level, level_preheater_LP.y) annotation (
      Line(
      points={{37.1,-139.9},{109,-139.9},{183,-139.9},{183,-103.5},{186.25,-103.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));

  connect(controlBus.y_FWH_HP_level, level_preheater_HP.y) annotation (Line(
      points={{37.1,-139.9},{183,-139.9},{183,-91.5},{186.25,-91.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FW_To_SG_1_flow, flow_to_SG_1.y) annotation (Line(
      points={{37.1,-139.9},{113,-139.9},{113,-139.5},{186.25,-139.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));

  connect(controlBus.y_FW_To_SG_2_flow, flow_to_SG_2.y) annotation (Line(
      points={{37.1,-139.9},{105,-139.9},{173,-139.9},{173,-147},{204,-147},{204,
          -129},{206.25,-129},{206.25,-128.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FW_To_SG_3_flow, flow_to_SG_3.y) annotation (Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{204,-147},{204,-139.5},{206.25,
          -139.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FW_To_FWH_HP_flow, flow_to_FWH_HW.y) annotation (Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{204,-147},{204,-116},{205,-116},
          {205,-115.5},{206.25,-115.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_TurbineHeader_pressure, pressure_steamHeader.y)
    annotation (Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{204,-147},{204,-101.5},{205.25,
          -101.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_Condenser_flow_in, flow_to_condenser.y) annotation (Line(
      points={{37.1,-139.9},{105,-139.9},{105,-140},{173,-140},{173,-147},{223,-147},
          {223,-128.5},{225.25,-128.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_Condenser_flow_out, flow_from_condenser.y) annotation (
      Line(
      points={{37.1,-139.9},{105,-139.9},{173,-139.9},{173,-147},{223,-147},{223,
          -140.5},{226.25,-140.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_LP_flow_out, flow_from_FWH_LP.y) annotation (Line(
      points={{37.1,-139.9},{174,-139.9},{174,-147},{223,-147},{223,-116},{225,-116},
          {225,-115.5},{225.25,-115.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_LP_flow_in, flow_to_FWH_LP.y) annotation (Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{223,-147},{223,-102.5},{225.25,
          -102.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_HP_flow_out, flow_from_FWH_HP.y) annotation (Line(
      points={{37.1,-139.9},{105,-139.9},{105,-140},{174,-140},{174,-147},{223,-147},
          {223,-90},{225,-90},{225,-89.5},{225.25,-89.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_HP_flow_in, flow_to_FWH_HP.y) annotation (Line(
      points={{37.1,-139.9},{105,-139.9},{173,-139.9},{173,-147},{223,-147},{223,
          -76.5},{224.25,-76.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_CondenserPump_dp, dp_condenser_pump.y) annotation (Line(
      points={{37.1,-139.9},{106,-139.9},{106,-140},{173,-140},{173,-147},{244,-147},
          {244,-140.5},{246.25,-140.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_LP_Pump_dp, dp_FWH_LP_pump.y) annotation (Line(
      points={{37.1,-139.9},{106,-139.9},{106,-140},{174,-140},{174,-147},{244,-147},
          {244,-129},{246,-129},{246,-128.5},{246.25,-128.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWH_HP_Valve_dp, dp_FWH_HP_valve.y) annotation (Line(
      points={{37.1,-139.9},{174,-139.9},{174,-147},{244,-147},{244,-114.5},{246.25,
          -114.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWControlValve_1_dp, dp_FWControlValve_1.y) annotation (
      Line(
      points={{37.1,-139.9},{105,-139.9},{173,-139.9},{173,-147},{244,-147},{244,
          -100.5},{246.25,-100.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWControlValve_2_dp, dp_FWControlValve_2.y) annotation (
      Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{244,-147},{244,-86.5},{246.25,
          -86.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_FWControlValve_3_dp, dp_FWControlValve_3.y) annotation (
      Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{244,-147},{244,-73.5},{246.25,
          -73.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(HPT.shaft_b, LPT_1.shaft_a) annotation (Line(points={{-38,51},{12.75,51},
          {12.75,50.5}},     color={0,0,0}));
  connect(controlBus.y_MSR_level, level_MSR.y) annotation (Line(
      points={{37.1,-139.9},{183,-139.9},{183,-79.5},{186.25,-79.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_MSR_flow_out, flow_from_MSR.y) annotation (Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{223,-147},{223,-64},{224.25,
          -64},{224.25,-63.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_MSR_flow_in, flow_to_MSR.y) annotation (Line(
      points={{37.1,-139.9},{106,-139.9},{106,-140},{174,-140},{174,-147},{223,-147},
          {223,-50.5},{224.25,-50.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.y_MSR_Valve_dp, dp_MSRLevelControlValve.y) annotation (
      Line(
      points={{37.1,-139.9},{173,-139.9},{173,-147},{244,-147},{244,-60.5},{246.25,
          -60.5}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(feed_SG1, header.port_a[1]) annotation (Line(
      points={{-169,110},{-155,110},{-155,64.6},{-148.6,64.6}},
      color={0,127,255},
      thickness=0.5));
  connect(feed_SG2, header.port_a[2]) annotation (Line(
      points={{-170,68},{-159.5,68},{-159.5,65},{-148.6,65}},
      color={0,127,255},
      thickness=0.5));
  connect(feed_SG3, header.port_a[3]) annotation (Line(
      points={{-170,25},{-155,25},{-155,65.4},{-148.6,65.4}},
      color={0,127,255},
      thickness=0.5));
  connect(TStopValve.port_a, header.port_b[1]) annotation (Line(points={{-133,65},
          {-141.4,65},{-141.4,64.55}},  color={0,127,255}));
  connect(controlBus.u_TStopValve, TStopValve.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-147},{-80,-147},{-80,75},{-126,75},{-126,70.6}},
      color={255,204,51},
      thickness=0.5));

  connect(TStopValve.port_b, vol2_turbine_HP_feed.port_a[1])
    annotation (Line(points={{-119,65},{-114.6,65}}, color={0,127,255}));
  connect(controlBus.u_TControlValve, TControlValve.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-145},{-80,-145},{-80,74},{-95,74},{-95,70.6}},
      color={255,204,51},
      thickness=0.5));

  connect(vol2_turbine_HP_feed.port_b[1], TControlValve.port_a) annotation (
      Line(
      points={{-107.4,65},{-104.7,65},{-102,65}},
      color={0,127,255},
      thickness=0.5));
  connect(TControlValve.port_b, vol3_turbine_HP_feed.port_a[1])
    annotation (Line(points={{-88,65},{-76.6,65}}, color={0,127,255}));
  connect(TBypassValve_1.port_a, header.port_b[2]) annotation (Line(points={{-66,105},
          {-86,105},{-86,103},{-141.4,103},{-141.4,64.85}},       color={0,127,255}));
  connect(controlBus.u_TBypassValve_1, TBypassValve_1.opening) annotation (Line(
      points={{37.1,-139.9},{19,-139.9},{19,-139},{-80,-139},{-80,117},{-59,117},
          {-59,110.6}},
      color={255,204,51},
      thickness=0.5));
  connect(TBypassValve_2.port_a, header.port_b[3]) annotation (Line(points={{-66,90},
          {-87,90},{-87,89},{-141.4,89},{-141.4,65.15}},      color={0,127,255}));
  connect(controlBus.u_TBypassValve_2, TBypassValve_2.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-80,-139.9},{-80,95.6},{-59,95.6}},
      color={255,204,51},
      thickness=0.5));
  connect(ValvMSR.port_a, header.port_b[4]) annotation (Line(points={{-66,76.5},
          {-102,76.5},{-102,78},{-141.4,78},{-141.4,65.45}},  color={0,127,255}));
  connect(controlBus.u_MSRControlValve_1, ValvMSR.opening) annotation (Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,81.7},{-59.5,81.7}},
      color={255,204,51},
      thickness=0.5));
  connect(drain_to_SG1, FWIsolationValve_1.port_b) annotation (Line(
      points={{-169,-30},{-149,-30}},
      color={0,127,255},
      thickness=0.5));
  connect(controlBus.u_FWIsolationValve_1, FWIsolationValve_1.opening)
    annotation (Line(
      points={{37.1,-139.9},{-26,-139.9},{-80,-139.9},{-80,-19},{-142,-19},{-142,
          -24.4}},
      color={255,204,51},
      thickness=0.5));
  connect(FWIsolationValve_1.port_a, vol2_drain_to_SG1.port_b[1])
    annotation (Line(points={{-135,-30},{-127.6,-30}}, color={0,127,255}));
  connect(FWControlValve_1.port_b, vol2_drain_to_SG1.port_a[1]) annotation (
      Line(points={{-110,-30},{-115,-30},{-115,-29.7},{-120.4,-29.7}}, color={0,
          127,255}));
  connect(controlBus.u_FWControlValve_1, FWControlValve_1.opening) annotation (
      Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,-19},{-103,-19},{-103,-24.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWBypassValve_1, FWBypassValve_1.opening) annotation (
      Line(
      points={{37.1,-139.9},{11,-139.9},{11,-141},{-80,-141},{-80,-43},{-103,-43},
          {-103,-47.4}},
      color={255,204,51},
      thickness=0.5));
  connect(FWBypassValve_1.port_b, vol2_drain_to_SG1.port_a[2]) annotation (Line(
        points={{-110,-53},{-116,-53},{-116,-30.3},{-120.4,-30.3}}, color={0,127,
          255}));
  connect(controlBus.u_FWControlValve_2, FWControlValve_2.opening) annotation (
      Line(
      points={{37.1,-139.9},{-81,-139.9},{-81,-68},{-103,-68},{-103,-75.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWBypassValve_2, FWBypassValve_2.opening) annotation (
      Line(
      points={{37.1,-139.9},{10,-139.9},{10,-141},{-80,-141},{-80,-94},{-103,-94},
          {-103,-99.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWControlValve_3, FWControlValve_3.opening) annotation (
      Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,-117},{-103,-117},{-103,-124.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus.u_FWBypassValve_3, FWBypassValve_3.opening) annotation (
      Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,-146.4},{-103,-146.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWIsolationValve_2, FWIsolationValve_2.opening)
    annotation (Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,-68},{-142,-68},{-142,-75.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWIsolationValve_3, FWIsolationValve_3.opening)
    annotation (Line(
      points={{37.1,-139.9},{-22,-139.9},{-22,-140},{-81,-140},{-81,-117},{-143,
          -117},{-143,-124.4}},
      color={255,204,51},
      thickness=0.5));
  connect(drain_to_SG2, FWIsolationValve_2.port_b) annotation (Line(
      points={{-169,-80},{-149,-80},{-149,-81}},
      color={0,127,255},
      thickness=0.5));
  connect(FWIsolationValve_2.port_a, vol2_drain_to_SG2.port_b[1])
    annotation (Line(points={{-135,-81},{-127.6,-81}}, color={0,127,255}));
  connect(drain_to_SG3, FWIsolationValve_3.port_b) annotation (Line(
      points={{-167,-131},{-159,-131},{-159,-130},{-150,-130}},
      color={0,127,255},
      thickness=0.5));
  connect(FWIsolationValve_3.port_a, vol2_drain_to_SG3.port_b[1]) annotation (
      Line(points={{-136,-130},{-127.6,-130},{-127.6,-130}}, color={0,127,255}));
  connect(vol2_drain_to_SG3.port_a[1], FWControlValve_3.port_b) annotation (
      Line(
      points={{-120.4,-129.7},{-116,-129.7},{-116,-130},{-110,-130}},
      color={0,127,255},
      thickness=0.5));
  connect(FWBypassValve_3.port_b, vol2_drain_to_SG3.port_a[2]) annotation (Line(
        points={{-110,-152},{-113,-152},{-113,-151},{-116,-151},{-116,-130.3},{-120.4,
          -130.3}}, color={0,127,255}));
  connect(vol2_drain_to_SG2.port_a[1], FWControlValve_2.port_b) annotation (
      Line(
      points={{-120.4,-80.7},{-110,-80.7},{-110,-81}},
      color={0,127,255},
      thickness=0.5));
  connect(FWBypassValve_2.port_b, vol2_drain_to_SG2.port_a[2]) annotation (Line(
        points={{-110,-105},{-113,-105},{-117,-105},{-117,-81.3},{-120.4,-81.3}},
        color={0,127,255}));
  connect(FWControlValve_1.port_a, vol_preheater_HP.port_b[1]) annotation (Line(
        points={{-96,-30},{-91,-30},{-91,-31},{-84,-31},{-84,-79.5},{-74.6,-79.5}},
        color={0,127,255}));
  connect(FWBypassValve_1.port_a, vol_preheater_HP.port_b[2]) annotation (Line(
        points={{-96,-53},{-88,-53},{-88,-79.7},{-74.6,-79.7}}, color={0,127,255}));
  connect(FWControlValve_2.port_a, vol_preheater_HP.port_b[3]) annotation (Line(
        points={{-96,-81},{-74.6,-81},{-74.6,-79.9}}, color={0,127,255}));
  connect(FWBypassValve_2.port_a, vol_preheater_HP.port_b[4]) annotation (Line(
        points={{-96,-105},{-92,-105},{-92,-104},{-86,-104},{-86,-80.1},{-74.6,-80.1}},
        color={0,127,255}));
  connect(FWControlValve_3.port_a, vol_preheater_HP.port_b[5]) annotation (Line(
        points={{-96,-130},{-83,-130},{-83,-80.3},{-74.6,-80.3}}, color={0,127,255}));
  connect(FWBypassValve_3.port_a, vol_preheater_HP.port_b[6]) annotation (Line(
        points={{-96,-152},{-84,-152},{-84,-80.5},{-74.6,-80.5}}, color={0,127,255}));
  connect(const.y, loss_preheater_HP.opening) annotation (Line(points={{-25.4,-64},
          {-25,-64},{-25,-63.5},{-28.2,-63.5}}, color={0,0,127}));
  connect(loss_preheater_HP.port_a, vol_feedWaterPump.port_b[1]) annotation (
      Line(points={{-33,-69},{-32,-69},{-32,-86},{-28.6,-86},{-28.6,-85}},
        color={0,127,255}));
  connect(controlBus.u_FWBlockValve_1, FWBlockValve_1.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{37.1,-122},{37.1,-61},{-5.75,-61},{-5.75,
          -65.65}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_FWBlockValve_2, FWBlockValve_2.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{37.1,-84},{-5.75,-84},{-5.75,-86.65}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus.u_FWBlockValve_3, FWBlockValve_3.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{37.1,-109},{-5.75,-109},{-5.75,-110.65}},
      color={255,204,51},
      thickness=0.5));

  connect(FWBlockValve_1.port_b, vol_feedWaterPump.port_a[1]) annotation (Line(
        points={{-11.5,-70.25},{-14,-70.25},{-14,-84.6},{-21.4,-84.6}}, color={0,
          127,255}));
  connect(FWBlockValve_2.port_b, vol_feedWaterPump.port_a[2]) annotation (Line(
        points={{-11.5,-91.25},{-16.25,-91.25},{-16.25,-85},{-21.4,-85}}, color=
         {0,127,255}));
  connect(FWBlockValve_3.port_b, vol_feedWaterPump.port_a[3]) annotation (Line(
        points={{-11.5,-115.25},{-16,-115.25},{-16,-85.4},{-21.4,-85.4}}, color=
         {0,127,255}));
  connect(controlBus.u_valve_HP, valve_preheater_hp.opening) annotation (Line(
      points={{37.1,-139.9},{-80,-139.9},{-80,15},{-57.6,15}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_MSRLevelControlValve_1, valve_msr_preheater_hp.opening)
    annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-20,-139.9},{-80,-139.9},{-80,2},{-22.6,
          2},{-22.6,16}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_valve_IP, valve_dearator.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-20,-139.9},{-80,-139.9},{-80,2},{5,2},
          {5,16},{24.4,16}},
      color={255,204,51},
      thickness=0.5));
  connect(valve_dearator1.opening, valve_dearator.opening) annotation (Line(
        points={{39.4,16},{38,16},{38,7},{28,7},{28,16},{24.4,16}}, color={0,0,127}));
  connect(controlBus.u_valve_LP, valve_reheater_lp.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-20,-139.9},{-80,-139.9},{-80,2},{65,
          2},{65,17},{89.4,17}},
      color={255,204,51},
      thickness=0.5));
  connect(valve_reheater_lp1.opening, valve_reheater_lp.opening) annotation (
      Line(points={{104.4,17},{97,17},{89.4,17}},         color={0,0,127}));
  connect(vol3_turbine_HP_feed.port_b[1], HPT.port_a) annotation (Line(
      points={{-69.4,65},{-58.4,65},{-58.4,55.4}},
      color={0,127,255},
      thickness=0.5));
  connect(valve_preheater_hp.port_a, HPT.drain1) annotation (Line(points={{-52,
          22},{-52.6,22},{-52.6,44.8}}, color={0,127,255}));
  connect(valve_dearator.port_a, LPT_1.drain1) annotation (Line(points={{30,23},
          {30,44.5},{29.5,44.5}}, color={0,127,255}));
  connect(valve_reheater_lp.port_a, LPT_1.drain2) annotation (Line(points={{95,
          24},{95,34},{33.5,34},{33.5,42.75}}, color={0,127,255}));
  connect(valve_dearator1.port_a, LPT_2.drain1) annotation (Line(points={{45,23},
          {45,23},{45,35},{45,37},{101.92,37},{101.92,45.24}}, color={0,127,255}));
  connect(valve_reheater_lp1.port_a, LPT_2.drain2) annotation (Line(points={{
          110,24},{110,29},{105.76,29},{105.76,43.56}}, color={0,127,255}));
  connect(controlBus.u_TValve_LPT_1, TValve_LPT1.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-20,-139.9},{-80,-139.9},{-80,2},{65,
          2},{65,76.5},{64,76.5},{31.9,76.5}},
      color={255,204,51},
      thickness=0.5));
  connect(vol_turbine_LPT_1_feed.port_b[1], LPT_1.port_a) annotation (Line(
      points={{27.5,62.6},{27.5,60.3},{27.5,58.75}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine_LPT_1_feed.port_a[1], TValve_LPT1.port_b) annotation (
      Line(
      points={{27.5,67.4},{27.5,69.2},{27.5,71}},
      color={0,127,255},
      thickness=0.5));
  connect(controlBus.u_TValve_LPT_2, TValve_LPT2.opening) annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{-80,-139.9},{-80,2},{65,2},{65,76.5},
          {95.6,76.5}},
      color={255,204,51},
      thickness=0.5));
  connect(LPT_2.port_a, vol_turbine_LPT_1_feed1.port_b[1]) annotation (Line(
      points={{100,58.92},{100,62.6},{100,62.6}},
      color={0,127,255},
      thickness=0.5));
  connect(vol_turbine_LPT_1_feed1.port_a[1], TValve_LPT2.port_b) annotation (
      Line(
      points={{100,67.4},{100,69.2},{100,71}},
      color={0,127,255},
      thickness=0.5));

  connect(controlBus.u_valve_preheat_HP, valve_FWH_HP_control.opening)
    annotation (Line(
      points={{37.1,-139.9},{37.1,-139.9},{37.1,-61},{15,-61},{15,-23},{-1,-23},
          {-1,-28.4}},
      color={255,204,51},
      thickness=0.5));
  connect(valve_FWH_HP_control.port_a, heightDiff3.port_b) annotation (Line(
        points={{-8,-34},{-30,-34},{-30,-75},{-53,-75},{-53,-67.2}}, color={0,127,
          255}));
  connect(vol_preheater_HP.port_a[1], FWH_HP.portCoolant_b) annotation (Line(
      points={{-67.4,-80},{-56,-80},{-56,-78},{-42,-78},{-42,-36}},
      color={0,127,255},
      thickness=0.5));
  connect(loss_preheater_HP.port_b, FWH_HP.portCoolant_a) annotation (Line(
        points={{-33,-58},{-34,-58},{-34,-30},{-42,-30}}, color={0,127,255}));
  connect(cooling_source.ports[1], condenser.portCoolant_a) annotation (Line(
        points={{213,23},{206,23},{206,11},{186,11}}, color={0,127,255}));
  connect(condenser.portCoolant_b, cooling_sink.ports[1]) annotation (Line(
      points={{186,5},{186,-5},{196,-5},{211,-5}},
      color={0,127,255},
      thickness=0.5));
  connect(TValve_LPT1.port_a, MSR.drain[1]) annotation (Line(points={{27.5,82},
          {27,82},{27,87},{27,86},{-2,86},{-2,78.25}}, color={0,127,255}));
  connect(TValve_LPT2.port_a, MSR.drain[2]) annotation (Line(points={{100,82},{
          100,82},{100,97},{-2,97},{-2,79.75}}, color={0,127,255}));
  connect(MSR.feed, HPT.drain2) annotation (Line(
      points={{-2,66.1},{-2,35},{-43.6,35},{-43.6,42.2}},
      color={0,127,255},
      thickness=0.5));
  connect(valve_preheater_hp.port_b, FWH_HP.portSteamFeed) annotation (Line(
        points={{-52,8},{-53,8},{-53,-18},{-60,-18},{-60,-27}}, color={0,127,255}));
  connect(valve_msr_preheater_hp.port_b, FWH_HP.portSteamFeed) annotation (Line(
        points={{-17,9},{-18,9},{-18,-12},{-18,-20},{-60,-20},{-60,-27}}, color=
         {0,127,255}));
  connect(FWH_HP.portFluidDrain, heightDiff3.port_a) annotation (Line(
      points={{-53,-41.8},{-53,-41.8},{-53,-58.8}},
      color={0,127,255},
      thickness=0.5));
  connect(heightDiff1.port_a, FWH_LP.portFluidDrain) annotation (Line(
      points={{104,-64.8},{104,-49.8},{104,-49.8}},
      color={0,127,255},
      thickness=0.5));
  connect(valve_reheater_lp.port_b, FWH_LP.portSteamFeed) annotation (Line(
        points={{95,10},{95,10},{95,-35},{97,-35}}, color={0,127,255}));
  connect(valve_reheater_lp1.port_b, FWH_LP.portSteamFeed) annotation (Line(
        points={{110,10},{110,-18},{95,-18},{95,-35},{97,-35}}, color={0,127,255}));
  connect(heightDiff.port_a, condenser.portFluidDrain) annotation (Line(
      points={{174,-12.8},{174,-7.9},{175,-7.9},{175,-0.8}},
      color={0,127,255},
      thickness=0.5));
  connect(LPT_2.drain, condenser.portSteamFeed) annotation (Line(
      points={{109.6,42.12},{109.6,14},{168,14}},
      color={0,127,255},
      thickness=0.5));
  connect(LPT_1.drain, condenser.portSteamFeed) annotation (Line(
      points={{37.5,41.25},{37.5,28},{148,28},{148,14},{168,14}},
      color={0,127,255},
      thickness=0.5));
  connect(TBypassValve_2.port_b, condenser.portSteamFeed)
    annotation (Line(points={{-52,90},{168,90},{168,14}}, color={0,127,255}));
  connect(TBypassValve_1.port_b, condenser.portSteamFeed) annotation (Line(
        points={{-52,105},{159,105},{159,14},{168,14}}, color={0,127,255}));
  connect(ValvMSR.port_b, MSR.hotFeed) annotation (Line(points={{-53,76.5},{-35,
          76.5},{-35,76},{-16.7,76}}, color={0,127,255}));
  connect(MSR.hotDrain, valve_msr_preheater_hp.port_a) annotation (Line(
      points={{-17,70},{-17,70},{-17,23}},
      color={0,127,255},
      thickness=0.5));
  connect(valve_dearator.port_b, dearator.steam) annotation (Line(points={{30,9},{
          30,9},{30,-38.55},{33.45,-38.55}},  color={0,127,255}));
  connect(valve_dearator1.port_b, dearator.steam) annotation (Line(points={{45,9},{
          45,9},{45,-16},{45,-32},{33.45,-32},{33.45,-38.55}},  color={0,127,255}));
  connect(MSR.condensateDrain, dearator.steam) annotation (Line(
      points={{9.7,66.1},{9.7,-12},{33.45,-12},{33.45,-38.55}},
      color={0,127,255},
      thickness=0.5));
  connect(dearator.feed, FWH_LP.portCoolant_b) annotation (Line(
      points={{49.55,-38.55},{49.55,-36},{87,-36},{87,-54},{117,-54},{117,-44},{
          115,-44}},
      color={0,127,255},
      thickness=0.5));
  connect(valve_FWH_HP_control.port_b, dearator.feed) annotation (Line(points={{6,-34},
          {28,-34},{49.55,-34},{49.55,-38.55}},        color={0,127,255}));
  connect(heightDiff2.port_a, dearator.drain) annotation (Line(
      points={{43,-70.8},{42,-70.8},{42,-51.3},{41.5,-51.3}},
      color={0,127,255},
      thickness=0.5));
  connect(FWBlockValve_1.port_a, FWPump_1.port_b) annotation (Line(points={{0,-70.25},
          {9,-70.25},{9,-75},{16,-75}}, color={0,127,255}));
  connect(FWBlockValve_2.port_a, FWPump_2.port_b) annotation (Line(points={{0,-91.25},
          {8,-91.25},{8,-97},{15,-97}}, color={0,127,255}));
  connect(FWBlockValve_3.port_a, FWPump_3.port_b) annotation (Line(points={{0,-115.25},
          {9,-115.25},{9,-119},{16,-119}}, color={0,127,255}));
  connect(pump_ip.port_a, heightDiff1.port_b) annotation (Line(
      points={{79,-89},{89,-89},{89,-88},{104,-88},{104,-73.2}},
      color={0,127,255},
      thickness=0.5));
  connect(pump_ip.port_b, dearator.feed) annotation (Line(
      points={{65,-89},{65,-38.55},{49.55,-38.55}},
      color={0,127,255},
      thickness=0.5));
  connect(FWPump_1.port_a, heightDiff2.port_b) annotation (Line(
      points={{30,-75},{35,-75},{35,-79.2},{43,-79.2}},
      color={0,127,255},
      thickness=0.5));
  connect(FWPump_2.port_a, heightDiff2.port_b) annotation (Line(
      points={{29,-97},{43,-97},{43,-79.2}},
      color={0,127,255},
      thickness=0.5));
  connect(FWPump_3.port_a, heightDiff2.port_b) annotation (Line(
      points={{30,-119},{43,-119},{43,-79.2}},
      color={0,127,255},
      thickness=0.5));
  connect(CondPump_1.port_a, heightDiff.port_b) annotation (Line(
      points={{163,-31},{174,-31},{174,-21.2}},
      color={0,127,255},
      thickness=0.5));
  connect(CondPump_2.port_a, heightDiff.port_b) annotation (Line(
      points={{164,-47},{174,-47},{174,-21.2}},
      color={0,127,255},
      thickness=0.5));
  connect(CondPump_3.port_a, heightDiff.port_b) annotation (Line(
      points={{165,-63},{174,-63},{174,-21.2}},
      color={0,127,255},
      thickness=0.5));
  connect(FWH_LP.portCoolant_a, CondPump_1.port_b) annotation (Line(
      points={{115,-38},{124,-38},{124,-37},{150,-37},{149,-31}},
      color={0,127,255},
      thickness=0.5));
  connect(CondPump_2.port_b, FWH_LP.portCoolant_a) annotation (Line(
      points={{150,-47},{131,-47},{131,-38},{115,-38}},
      color={0,127,255},
      thickness=0.5));
  connect(CondPump_3.port_b, FWH_LP.portCoolant_a) annotation (Line(
      points={{151,-63},{125,-63},{125,-38},{115,-38}},
      color={0,127,255},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-170,
            -160},{270,120}},
        grid={1,1},
        initialScale=0.1)),                    Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-170,-160},{270,120}},
        grid={1,1},
        initialScale=0.1),
        graphics={
        Ellipse(
          extent={{218,-53},{200,-69}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,1},{-15,1},{-15,-1},{-16,-1},{-15,-1},{-32,-1},{-32,1}},
          lineColor={216,112,112},
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid,
          origin={-44,-32},
          rotation=90),
        Polygon(
          points={{-109,76},{-93,68},{-77,76},{-77,60},{-93,68},{-109,60},{-109,
              76}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-79,91},{-108,76}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-113,85},{-69,75}},
          lineColor={255,255,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,68},{-95,84}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Description</h4>
<p>Example of a steam cycle configuration with reheat, two pre-heaters and one dearator.</p>
</html>"));
end Rankine;
