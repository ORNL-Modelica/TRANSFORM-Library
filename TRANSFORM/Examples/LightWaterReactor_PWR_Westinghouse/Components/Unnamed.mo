within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Components;
model Unnamed
  replaceable package Medium =
      Modelica.Media.Water.StandardWater                          constrainedby
    Modelica.Media.Interfaces.PartialTwoPhaseMedium annotation(choicesAllMatching);
 constant Real conversion_feet_to_m=0.3048 "Conversion feet to meter";
 constant Real conversion_inch_to_m=0.0254 "Inch to meter";
 parameter Real circulationRatio=2.9 "Circulation ratio for feed water" annotation(Dialog(group="Inputs"));
  final parameter Modelica.Units.SI.Area Aheat_calc_outerTubes=1838*60*
      conversion_feet_to_m*3.141*1.25*conversion_inch_to_m;
  Real drum_level_percentage=drum.geometry.level_meas_percentage "Drum level percentage";
  Fluid.Volumes.BoilerDrum
                     drum(
    portPosition_downcomer=-drum.geometry.length/2,
    h_liquid_start=Medium.bubbleEnthalpy(Medium.setSat_p(nominalData.p_start_boiler)),
    h_vapor_start=Medium.dewEnthalpy(Medium.setSat_p(nominalData.p_start_boiler)),
    Twall_start=Medium.saturationTemperature(nominalData.p_start_boiler),
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_vapor_start=nominalData.p_start_boiler,
    d_wall=7000,
    cp_wall=500,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder (
        length=26*conversion_feet_to_m,
        orientation="Vertical",
        r_inner=12*conversion_feet_to_m - drum.geometry.th_wall,
        th_wall=0.04),
    alpha_external=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{-20,-14},{20,26}}, rotation=0)));
  Fluid.Valves.ValveCompressible MSIValve(
    m_flow_nominal=nominalData.m_flow_feedWater_nominal,
    p_nominal=nominalData.p_boiler_nominal,
    checkValve=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=10000,
    rho_nominal=Medium.density_pTX(
        nominalData.p_boiler_nominal,
        Medium.saturationTemperature(nominalData.p_start_boiler) + 1,
        Medium.X_default)) "Main Steam Isolation Valve"
    annotation (Placement(transformation(extent={{0,46},{20,66}}, rotation=0)));
  TRANSFORM_Examples.SteamRankine_BalanceOfPlant.Components.PumpSimple
    circulationPump(
    V=0.2,
    h_start=900e3,
    use_N_input=true,
    eta=0.9,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    m_flow_start=nominalData.m_flow_nom_circulation,
    p_b_start=circulationPump.p_a_start + nominalData.dp_start_riser,
    V_flow_nominal=nominalData.m_flow_start_circulation/
        circulationPump.Medium.bubbleDensity(circulationPump.Medium.setSat_p(
        nominalData.p_start_boiler)),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_a_start=nominalData.p_start_boiler + (-60*conversion_feet_to_m)*drum.g_n_start
        *circulationPump.Medium.bubbleDensity(circulationPump.Medium.setSat_p(
        nominalData.p_start_boiler)))
    annotation (Placement(transformation(extent={{10,-94},{-10,-74}})));
  Fluid.FittingsAndResistances.ElevationChange
                                         heightDiff(dheight=-heightDiff_riser.dheight,
      redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={14,-60})));
  dataold nominalData(p_boiler_nominal=nominalData.p_steam_nominal + 0.2e5)
    annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
  Modelica.Blocks.Sources.RealExpression universalSensor(y=circulationRatio*
        nominalData.m_flow_feedWater_nominal)
    annotation (Placement(transformation(extent={{58,-85},{44,-73}})));
  Fluid.Volumes.MixingVolume              vol_subcool(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=nominalData.p_start_boiler - 0.1e5,
    use_T_start=false,
    h_start=900e3,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=2,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{34,-60},{14,-40}})));
  Fluid.Valves.ValveIncompressible orificeLiquid(
    m_flow_nominal=nominalData.m_flow_feedWater_nominal,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=10000,
    rho_nominal=1000) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={17,-25})));
  Fluid.Sensors.Pressure
                   pSteam(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-54,28},{-44,36}})));
  Fluid.Sensors.MassFlowRate
                       sensorSteamFlow(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-16,40})));
  Fluid.Sensors.MassFlowRate
                       sensorFeedWaterFlow(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={68,-42})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{39,-30},{31,-22}})));
  Modelica.Blocks.Math.Product massFlowInverse
    annotation (Placement(transformation(extent={{30,-79},{20,-69}})));
  Modelica.Blocks.Sources.RealExpression k(y=circulationPump.N_nominal/(
        circulationPump.V_flow_nominal*circulationPump.d))
    annotation (Placement(transformation(extent={{58,-75},{44,-63}})));
  Fluid.Volumes.MixingVolume
                       riser(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start=circulationPump.p_b_start,
    use_T_start=false,
    h_start=circulationPump.h_start,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1838
            *(0.946*conversion_inch_to_m)^2/4*Modelica.Constants.pi*60*
            conversion_feet_to_m),
    nPorts_b=1,
    nPorts_a=1,
    use_HeatPort=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-19,-75})));
  Fluid.Volumes.MixingVolume
                       riser1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    use_T_start=false,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1838
            *(0.946*conversion_inch_to_m)^2/4*Modelica.Constants.pi*60*
            conversion_feet_to_m),
    p_start=nominalData.p_start_boiler,
    h_start=nominalData.riser_vaporQuality_start_out*(Medium.dewEnthalpy(
        Medium.setSat_p(nominalData.p_start_boiler)) - Medium.bubbleEnthalpy(
        Medium.setSat_p(nominalData.p_start_boiler))) + Medium.bubbleEnthalpy(
        Medium.setSat_p(nominalData.p_start_boiler)),
    nPorts_a=1,
    nPorts_b=1,
    use_HeatPort=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
                annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-19,-51})));
  Fluid.FittingsAndResistances.NominalLoss generic(
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    dp_nominal=nominalData.dp_riser_nominal,
    d_nominal=640) annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=90,
        origin={-19,-63})));
  Fluid.FittingsAndResistances.NominalLoss generic1(
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    dp_nominal=nominalData.dp_riser_nominal,
    d_nominal=640) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-19,-37})));
  Fluid.FittingsAndResistances.ElevationChange
                                         heightDiff_riser(redeclare package
      Medium = Modelica.Media.Water.StandardWater, dheight=60*
        conversion_feet_to_m) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=270,
        origin={-19,-23})));
  Fluid.BoundaryConditions.Boundary_ph boundary(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=nominalData.p_boiler_nominal,
    h=3e6,
    nPorts=1) annotation (Placement(transformation(extent={{130,52},{110,72}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=nominalData.m_flow_feedWater_nominal,
    T=nominalData.T_nom_feedWater)
    annotation (Placement(transformation(extent={{142,-68},{122,-48}})));
  Data.Data_Basic data
    annotation (Placement(transformation(extent={{-134,50},{-114,70}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-26,74},{-6,94}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow heat(use_port=true)
    annotation (Placement(transformation(
        origin={-93,-67},
        extent={{-7,7},{7,-7}},
        rotation=0)));
  HeatAndMassTransfer.Volumes.SimpleWall_noMedia riserWall[2](
    each th=0.152*conversion_inch_to_m,
    each surfaceArea=33080*conversion_feet_to_m^2,
    each d=7880,
    each cp=500,
    each lambda=21,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    each T_start=Medium.saturationTemperature(nominalData.p_start_boiler) + 3,
    each exposeState_a=true) annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-61,-67})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Collector collector(n=2)
    annotation (Placement(transformation(extent={{-72,-72},{-82,-62}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection[2](each
      surfaceArea=1838*(0.946*conversion_inch_to_m)*Modelica.Constants.pi*60*
        conversion_feet_to_m, each alpha=10000)
    annotation (Placement(transformation(extent={{-50,-74},{-34,-60}})));
  Modelica.Blocks.Sources.Constant const3(each k=4.19348e8)
    annotation (Placement(transformation(extent={{-146,-66},{-126,-46}})));
equation
  connect(sensorSteamFlow.port_b,MSIValve. port_a)
    annotation (Line(points={{-16,46},{-16,56},{0,56}}, color={0,127,255}));
  connect(orificeLiquid.opening,const. y) annotation (Line(points={{22.6,-25},{26.3,
          -25},{26.3,-26},{30.6,-26}}, color={0,0,127}));
  connect(circulationPump.port_a,heightDiff. port_b) annotation (Line(
      points={{10,-84},{14,-84},{14,-65.6}},
      color={0,127,255},
      thickness=0.5));
  connect(drum.steamPort,sensorSteamFlow. port_a) annotation (Line(
      points={{14,21.2},{14,24.6},{-16,24.6},{-16,34}},
      color={0,127,255},
      thickness=0.5));
  connect(pSteam.port,sensorSteamFlow. port_a)
    annotation (Line(points={{-49,28},{-16,28},{-16,34}}, color={0,127,255}));
  connect(drum.downcomerPort,orificeLiquid. port_a) annotation (Line(
      points={{14,-10},{16,-10},{16,-18},{17,-18}},
      color={0,127,255},
      thickness=0.5));
  connect(k.y,massFlowInverse. u1) annotation (Line(points={{43.3,-69},{38,-69},
          {38,-71},{31,-71}}, color={0,0,127}));
  connect(universalSensor.y,massFlowInverse. u2) annotation (Line(points={{43.3,
          -79},{38,-79},{38,-77},{31,-77}}, color={0,0,127}));
  connect(massFlowInverse.y,circulationPump. N_input) annotation (Line(points={{19.5,
          -74},{0,-74}},                  color={0,0,127}));
  connect(riser.port_b[1],generic. port_a) annotation (Line(
      points={{-19,-70.8},{-19,-67.9}},
      color={0,127,255},
      thickness=0.5));
  connect(generic.port_b,riser1. port_a[1]) annotation (Line(
      points={{-19,-58.1},{-19,-55.2}},
      color={0,127,255},
      thickness=0.5));
  connect(circulationPump.port_b,riser. port_a[1]) annotation (Line(
      points={{-10,-84},{-19,-84},{-19,-79.2}},
      color={0,127,255},
      thickness=0.5));
  connect(heightDiff_riser.port_a,generic1. port_b) annotation (Line(
      points={{-19,-27.9},{-19,-32.1}},
      color={0,127,255},
      thickness=0.5));
  connect(drum.riserPort,heightDiff_riser. port_b) annotation (Line(
      points={{-14,-10},{-14,-12},{-19,-12},{-19,-18.1}},
      color={0,127,255},
      thickness=0.5));
  connect(riser1.port_b[1],generic1. port_a) annotation (Line(
      points={{-19,-46.8},{-19,-41.9}},
      color={0,127,255},
      thickness=0.5));
  connect(boundary1.ports[1], sensorFeedWaterFlow.port_a) annotation (Line(
        points={{122,-58},{98,-58},{98,-42},{74,-42}}, color={0,127,255}));
  connect(const1.y, MSIValve.opening)
    annotation (Line(points={{-5,84},{10,84},{10,64}}, color={0,0,127}));
  connect(riserWall.port_a,convection. port_a) annotation (Line(
      points={{-54,-67},{-47.6,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(collector.port_a,riserWall. port_b) annotation (Line(
      points={{-72,-67},{-70,-67},{-70,-67},{-68,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(heat.port,collector. port_b) annotation (Line(
      points={{-86,-67},{-86,-67},{-86,-67},{-82,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(convection[1].port_b, riser.heatPort) annotation (Line(points={{-36.4,
          -67},{-28,-67},{-28,-75},{-23.2,-75}}, color={191,0,0}));
  connect(riser1.heatPort, convection[2].port_b) annotation (Line(points={{-23.2,
          -51},{-28,-51},{-28,-67},{-36.4,-67}}, color={191,0,0}));
  connect(const3.y, heat.Q_flow_ext) annotation (Line(points={{-125,-56},{-112,-56},
          {-112,-67},{-95.8,-67}}, color={0,0,127}));
  connect(MSIValve.port_b, boundary.ports[1]) annotation (Line(points={{20,56},{
          66,56},{66,62},{110,62}}, color={0,127,255}));
  connect(vol_subcool.port_b[1], heightDiff.port_a) annotation (Line(points={{18,
          -50.5},{14,-50.5},{14,-54.4}}, color={0,127,255}));
  connect(vol_subcool.port_a[1], sensorFeedWaterFlow.port_b) annotation (Line(
        points={{30,-50},{46,-50},{46,-42},{62,-42}}, color={0,127,255}));
  connect(orificeLiquid.port_b, vol_subcool.port_b[2]) annotation (Line(points={
          {17,-32},{16,-32},{16,-49.5},{18,-49.5}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Unnamed;
