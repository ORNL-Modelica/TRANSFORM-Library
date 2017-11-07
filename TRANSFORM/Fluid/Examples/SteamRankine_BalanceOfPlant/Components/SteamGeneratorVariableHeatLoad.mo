within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model SteamGeneratorVariableHeatLoad "Variable heat load"
  extends
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialSteamGenerator(
      heightDiff(dheight=-heightDiff_riser.dheight), drum(
        portPosition_downcomer=-drum.geometry.length/2));
 Modelica.SIunits.Velocity riser_velocity=riser.port_a[1].m_flow/circulationPump.d/(1838*(0.946*conversion_inch_to_m)^2/4*Modelica.Constants.pi);
 Modelica.SIunits.HeatFlowRate Q_riser;
  Modelica.Blocks.Interfaces.RealInput Q_fromPHS
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
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
    each T_start=Medium.saturationTemperature(initData.p_start_boiler) + 3,
    each exposeState_a=true) annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-61,-67})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Collector collector(n=2)
    annotation (Placement(transformation(extent={{-72,-72},{-82,-62}})));
  Volumes.MixingVolume riser(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start=circulationPump.p_b_start,
    use_T_start=false,
    h_start=circulationPump.h_start,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=1838*(0.946*conversion_inch_to_m)^2/4*Modelica.Constants.pi*60*
        conversion_feet_to_m),
    nPorts_b=1,
    nPorts_a=1,
    use_HeatPort=true)
                annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-19,-79})));
  Volumes.MixingVolume riser1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    use_T_start=false,
redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=1838*(0.946*conversion_inch_to_m)^2/4*Modelica.Constants.pi*60*
        conversion_feet_to_m),
    p_start=initData.p_start_boiler,
    h_start=initData.riser_vaporQuality_start_out*(Medium.dewEnthalpy(
        Medium.setSat_p(initData.p_start_boiler)) - Medium.bubbleEnthalpy(Medium.setSat_p(initData.p_start_boiler)))
         + Medium.bubbleEnthalpy(Medium.setSat_p(initData.p_start_boiler)),
    nPorts_a=1,
    nPorts_b=1,
    use_HeatPort=true)
                annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-19,-55})));
  FittingsAndResistances.NominalLoss generic(
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    dp_nominal=nominalData.dp_nom_riser,
    d_nominal=640) annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=90,
        origin={-19,-67})));
  FittingsAndResistances.NominalLoss generic1(
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    dp_nominal=nominalData.dp_nom_riser,
    d_nominal=640) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-19,-41})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection[2](each
      surfaceArea=1838*(0.946*conversion_inch_to_m)*Modelica.Constants.pi*60*
        conversion_feet_to_m, each alpha=10000)
    annotation (Placement(transformation(extent={{-50,-74},{-34,-60}})));
  FittingsAndResistances.ElevationChange heightDiff_riser(redeclare package
      Medium = Modelica.Media.Water.StandardWater, dheight=60*
        conversion_feet_to_m) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=270,
        origin={-19,-27})));
equation
   // Q_riser=nominalData.m_flow_nom_circulation*initData.riser_vaporQuality_start_out*(Medium.dewEnthalpy_pX(initData.p_start_boiler) - Medium.bubbleEnthalpy_pX(initData.p_start_boiler));
  Q_riser=nominalData.m_flow_nom_feedWater*(Medium.dewEnthalpy(Medium.setSat_p(nominalData.p_nom_boiler)) - Medium.specificEnthalpy_pTX(nominalData.p_nom_boiler,nominalData.T_nom_feedWater,Medium.reference_X));
  connect(riser.port_b[1], generic.port_a) annotation (Line(
      points={{-19,-74.8},{-19,-71.9}},
      color={0,127,255},
      thickness=0.5));
  connect(generic.port_b, riser1.port_a[1]) annotation (Line(
      points={{-19,-62.1},{-19,-59.2}},
      color={0,127,255},
      thickness=0.5));
  connect(circulationPump.port_b, riser.port_a[1]) annotation (Line(
      points={{-10,-88},{-19,-88},{-19,-83.2}},
      color={0,127,255},
      thickness=0.5));
  connect(convection[1].port_b, riser.heatPort) annotation (Line(
      points={{-36.4,-67},{-32,-67},{-32,-79},{-23.2,-79}},
      color={191,0,0},
      thickness=0.5));
  connect(heightDiff_riser.port_a, generic1.port_b) annotation (Line(
      points={{-19,-31.9},{-19,-36.1}},
      color={0,127,255},
      thickness=0.5));
  connect(drum.riserPort, heightDiff_riser.port_b) annotation (Line(
      points={{-14,-12.8},{-14,-16},{-19,-16},{-19,-22.1}},
      color={0,127,255},
      thickness=0.5));
  connect(riser1.port_b[1], generic1.port_a) annotation (Line(
      points={{-19,-50.8},{-19,-49.4},{-19,-45.9}},
      color={0,127,255},
      thickness=0.5));
  connect(convection[2].port_b, riser1.heatPort) annotation (Line(
      points={{-36.4,-67},{-32,-67},{-32,-55},{-23.2,-55}},
      color={191,0,0},
      thickness=0.5));
  connect(riserWall.port_a, convection.port_a) annotation (Line(
      points={{-54,-67},{-47.6,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(collector.port_a, riserWall.port_b) annotation (Line(
      points={{-72,-67},{-70,-67},{-70,-67},{-68,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(heat.port, collector.port_b) annotation (Line(
      points={{-86,-67},{-86,-67},{-86,-67},{-82,-67}},
      color={191,0,0},
      thickness=0.5));
  connect(Q_fromPHS, heat.Q_flow_ext) annotation (Line(points={{-120,-20},{-98,-20},
          {-98,-67},{-95.8,-67}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SteamGeneratorVariableHeatLoad;
