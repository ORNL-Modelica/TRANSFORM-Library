within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
partial model PartialSteamGenerator "Drum boiler with natural circulation"
  replaceable package Medium =
      Modelica.Media.Water.StandardWater                          constrainedby
    Modelica.Media.Interfaces.PartialTwoPhaseMedium annotation(choicesAllMatching);
 constant Real conversion_feet_to_m=0.3048 "Conversion feet to meter";
 constant Real conversion_inch_to_m=0.0254 "Inch to meter";
 input Real circulationRatio=2.9 "Circulation ratio for feed water" annotation(Dialog(group="Inputs"));
 final parameter Modelica.SIunits.Area Aheat_calc_outerTubes=1838*60*conversion_feet_to_m*3.141*1.25*conversion_inch_to_m;
  Real drum_level_percentage=100*(drum.geometry.level - drum.geometry.level_min)/(drum.geometry.level_max -
      drum.geometry.level_min) "Drum level percentage";

  Volumes.Drum drum(
    p_start=initData.p_start_boiler,
    h_liquid_start=Medium.bubbleEnthalpy(Medium.setSat_p(initData.p_start_boiler)),
    h_vapor_start=Medium.dewEnthalpy(Medium.setSat_p(initData.p_start_boiler)),
    Twall_start=Medium.saturationTemperature(initData.p_start_boiler),
    level_start=initData.boiler_level_start,
    alpha_external=10,
    Cwall=(drum.geometry.length*3.14*2*drum.geometry.r_outer + 2*3.14*drum.geometry.r_outer^2)*(drum.geometry.r_outer
         - drum.geometry.r_inner)*7000*500,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder
        (
        r_inner=12*conversion_feet_to_m - 0.04,
        r_outer=12*conversion_feet_to_m,
        length=26*conversion_feet_to_m,
        DrumOrientation=1))                                        annotation (
      Placement(transformation(extent={{20,-18},{-20,22}}, rotation=0)));

  Valves.ValveCompressible                MSIValve(
    m_flow_nominal=nominalData.m_flow_nom_feedWater,
    p_nominal=nominalData.p_nom_boiler,
    rho_nominal=MSIValve.Medium.density_pTX(
        nominalData.p_nom_boiler,
        MSIValve.Medium.saturationTemperature(initData.p_start_boiler) + 1,
        MSIValve.Medium.X_default),
    checkValve=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=10000)
                   "Main Steam Isolation Valve"
    annotation (Placement(transformation(extent={{0,42},{20,62}}, rotation=0)));

  Interfaces.FluidPort_State port_feedWater(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(extent={{90,-90},{110,-70}}), iconTransformation(extent=
            {{90,-90},{110,-70}})));
  Interfaces.FluidPort_Flow                 drain_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{90,42},{110,62}})));
  PumpSimple                                              circulationPump(
    V=0.2,
    h_start=900e3,
    use_N_input=true,
    eta=0.9,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=initData.p_start_boiler + (-60*conversion_feet_to_m)*drum.g_n
        *circulationPump.Medium.bubbleDensity(circulationPump.Medium.setSat_p(initData.p_start_boiler)),
    m_flow_nominal=nominalData.m_flow_nom_circulation,
    m_flow_start=nominalData.m_flow_nom_circulation,
    p_b_start=circulationPump.p_a_start + initData.dp_start_riser,
    V_flow_nominal=initData.m_flow_start_circulation/circulationPump.Medium.bubbleDensity(
        circulationPump.Medium.setSat_p(initData.p_start_boiler)),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{10,-98},{-10,-78}})));

  FittingsAndResistances.ElevationChange heightDiff(redeclare package Medium =
        Modelica.Media.Water.StandardWater, dheight=-60*conversion_feet_to_m)
    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={14,-64})));
  Records.BoilerNominalValues nominalData(p_nom_boiler=Records.NominalData.steamPressure_Pa
         + 0.2e5)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  replaceable Records.BoilerStartValues initData(
    p_start_boiler=nominalData.p_nom_boiler,
    m_flow_start_feedWater=nominalData.m_flow_nom_feedWater,
    m_flow_start_circulation=nominalData.m_flow_nom_circulation,
    boiler_level_start=0,
    dp_start_riser=nominalData.dp_nom_riser) constrainedby
    Records.BoilerStartValues(
    p_start_boiler=nominalData.p_nom_boiler,
    m_flow_start_feedWater=nominalData.m_flow_nom_feedWater,
    m_flow_start_circulation=nominalData.m_flow_nom_circulation,
    boiler_level_start=0,
    dp_start_riser=nominalData.dp_nom_riser)
    annotation (Placement(transformation(extent={{-52,40},{-32,60}})));
  Modelica.Blocks.Sources.RealExpression universalSensor(y=
        circulationRatio*nominalData.m_flow_nom_feedWater)
    annotation (Placement(transformation(extent={{58,-89},{44,-77}})));
  Control.ControlBuses.ControlBus_SteamGenerator controlBus
    annotation (Placement(transformation(extent={{-20,-140},{20,-100}})));
  Modelica.Blocks.Sources.RealExpression level_percentage(y=
        drum_level_percentage)
    annotation (Placement(transformation(extent={{-36,-118},{-22,-106}})));
  Modelica.Blocks.Sources.RealExpression drum_pressure(y=
        drum.p)
    annotation (Placement(transformation(extent={{-36,-106},{-22,-94}})));
  Volumes.MixingVolume                    vol_turbine_HP_feed(
    nPorts_a=1,
    nPorts_b=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_start=initData.p_start_boiler - 0.1e5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=Medium.saturationTemperature(initData.p_start_boiler) + 5,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (       V=20))
    annotation (Placement(transformation(extent={{23,43},{42,62}})));

  Valves.ValveCompressible                SGBlockValve(
    m_flow_nominal=nominalData.m_flow_nom_feedWater,
    rho_nominal=SGBlockValve.Medium.density_pTX(
        nominalData.p_nom_boiler,
        SGBlockValve.Medium.saturationTemperature(initData.p_start_boiler) + 1,
        SGBlockValve.Medium.X_default),
    p_nominal=nominalData.p_nom_boiler,
    checkValve=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=10000)
                   "Steam Generator Block Valve" annotation (Placement(
        transformation(extent={{44,42},{64,62}}, rotation=0)));

  Modelica.Blocks.Sources.RealExpression sensor_feedWaterFlow(y=
        sensorFeedWaterFlow.m_flow)
    annotation (Placement(transformation(extent={{34,-106},{20,-94}})));
  Modelica.Blocks.Sources.RealExpression sensor_steamMassFlow(y=
        sensorSteamFlow.m_flow)
    annotation (Placement(transformation(extent={{34,-118},{20,-106}})));
  Volumes.MixingVolume                    vol_subcool(
    nPorts_a=2,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=initData.p_start_boiler - 0.1e5,
    use_T_start=false,
    h_start=900e3,
    nPorts_b=1,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1))
    annotation (Placement(transformation(extent={{14,-58},{34,-38}})));

  Valves.ValveIncompressible                          orificeLiquid(
    m_flow_nominal=nominalData.m_flow_nom_feedWater,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=10000,
    rho_nominal=1000)
                annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={17,-29})));

  Sensors.Pressure pSteam(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-54,24},{-44,32}})));
  Sensors.MassFlowRate sensorSteamFlow(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-16,36})));
  Sensors.MassFlowRate sensorFeedWaterFlow(redeclare package Medium =
        Modelica.Media.Water.StandardWater) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={68,-46})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{39,-34},{31,-26}})));
  Modelica.Blocks.Math.Product massFlowInverse
    annotation (Placement(transformation(extent={{30,-83},{20,-73}})));
  Modelica.Blocks.Sources.RealExpression k(y=circulationPump.N_nominal/(
        circulationPump.V_flow_nominal*circulationPump.d))
    annotation (Placement(transformation(extent={{58,-79},{44,-67}})));
equation

  connect(level_percentage.y, controlBus.y_drum_level) annotation (Line(points={{-21.3,
          -112},{-21.3,-112},{0,-112},{0,-116},{0,-119.9},{0.1,-119.9}},
        color={0,0,127}));
  connect(drum_pressure.y, controlBus.y_drum_pressure) annotation (Line(points={{-21.3,
          -100},{-21.3,-100},{0.1,-100},{0.1,-119.9}},     color={0,0,127}));

  connect(sensor_feedWaterFlow.y, controlBus.y_drum_FeedWaterFlow) annotation (
      Line(points={{19.3,-100},{0.1,-100},{0.1,-119.9}},
                                                       color={0,0,127}));
  connect(sensor_steamMassFlow.y, controlBus.y_drum_steamFlow) annotation (Line(
        points={{19.3,-112},{0.1,-112},{0.1,-119.9}},
                                                    color={0,0,127}));
  connect(MSIValve.port_b, vol_turbine_HP_feed.port_a[1]) annotation (Line(
        points={{20,52},{26.8,52},{26.8,52.5}}, color={0,127,255}));
  connect(vol_turbine_HP_feed.port_b[1], SGBlockValve.port_a) annotation (Line(
      points={{38.2,52.5},{41.1,52.5},{41.1,52},{44,52}},
      color={0,127,255},
      thickness=0.5));
  connect(SGBlockValve.port_b, drain_steam)
    annotation (Line(points={{64,52},{100,52}}, color={0,127,255}));
  connect(controlBus.u_SGBlockValve, SGBlockValve.opening) annotation (Line(
      points={{0.1,-119.9},{-100,-119.9},{-100,80},{54,80},{54,60}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.u_MSIValve, MSIValve.opening) annotation (Line(
      points={{0.1,-119.9},{-100,-119.9},{-100,80},{10,80},{10,60}},
      color={255,204,51},
      thickness=0.5));
  connect(sensorSteamFlow.port_b, MSIValve.port_a)
    annotation (Line(points={{-16,42},{-16,52},{0,52}}, color={0,127,255}));
  connect(port_feedWater, sensorFeedWaterFlow.port_a) annotation (Line(
      points={{100,-80},{90,-80},{90,-78},{80,-78},{80,-46},{74,-46}},
      color={0,127,255},
      thickness=0.5));
  connect(orificeLiquid.port_b, vol_subcool.port_a[1]) annotation (Line(points={
          {17,-36},{16,-36},{16,-48.5},{18,-48.5}}, color={0,127,255}));
  connect(heightDiff.port_a, vol_subcool.port_a[2]) annotation (Line(
      points={{14,-58.4},{14,-47.5},{18,-47.5}},
      color={0,127,255},
      thickness=0.5));
  connect(orificeLiquid.opening, const.y) annotation (Line(points={{22.6,-29},{26.3,
          -29},{26.3,-30},{30.6,-30}}, color={0,0,127}));
  connect(vol_subcool.port_b[1], sensorFeedWaterFlow.port_b) annotation (Line(
      points={{30,-48},{46,-48},{46,-46},{62,-46}},
      color={0,127,255},
      thickness=0.5));
  connect(circulationPump.port_a, heightDiff.port_b) annotation (Line(
      points={{10,-88},{14,-88},{14,-69.6}},
      color={0,127,255},
      thickness=0.5));
  connect(drum.steamPort, sensorSteamFlow.port_a) annotation (Line(
      points={{-14,17.2},{-14,20.6},{-16,20.6},{-16,30}},
      color={0,127,255},
      thickness=0.5));
  connect(pSteam.port, sensorSteamFlow.port_a)
    annotation (Line(points={{-49,24},{-16,24},{-16,30}}, color={0,127,255}));
  connect(drum.downcomerPort, orificeLiquid.port_a) annotation (Line(
      points={{14,-12.8},{16,-12.8},{16,-22},{17,-22}},
      color={0,127,255},
      thickness=0.5));
  connect(k.y, massFlowInverse.u1) annotation (Line(points={{43.3,-73},{38,-73},
          {38,-75},{31,-75}}, color={0,0,127}));
  connect(universalSensor.y, massFlowInverse.u2) annotation (Line(points={{43.3,
          -83},{38,-83},{38,-81},{31,-81}}, color={0,0,127}));
  connect(massFlowInverse.y, circulationPump.N_input) annotation (Line(points={{
          19.5,-78},{10.75,-78},{0,-78}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-120},{100,
            100}})),
    Documentation(revisions="<html>
<!--copyright-->
</html>",                       info="<html>
<h4>Description</h4>
<p>This example shows a natural circulation boiler with pressure and a level control. In the beginning there will be some transients due to the system is not started in steady-state.</p>
<p>At time=170 s the heat flow rate is decreased. This will decrease the amount of steam produced in the drum and the pressure will decrease. The pressure control system will then decrease the valve opening at the steam port in order to maintain the desired pressure.</p>
<h4>Simulation setup</h4>
<p>Simulate for 500s using Dassl with a tolerance of 1e-5.</p>
<h4>Output</h4>
<p>Variables of interest are pressure p, temperaure T and level y in component drum. </p>
</html>"),
    experiment(StopTime=500, Tolerance=1e-005),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
         graphics={
        Rectangle(
          extent={{-100,100},{118,-126}},
          lineColor={255,255,255},
          pattern=LinePattern.Dash,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,1},{34,-1}},
          lineColor={105,149,214},
          lineThickness=0.5,
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid,
          origin={-17,-58},
          rotation=90),
        Ellipse(
          extent={{-32,32},{32,-30}},
          lineColor={105,149,214},
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,44},{42,0}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-32,32},{32,-30}}, lineColor={105,149,214}),
        Rectangle(
          extent={{-36,1},{36,-1}},
          lineColor={105,149,214},
          lineThickness=0.5,
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid,
          origin={17,-58},
          rotation=90),
        Rectangle(
          extent={{-18,1},{18,-1}},
          lineColor={105,149,214},
          lineThickness=0.5,
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid,
          origin={0,-93},
          rotation=180),
        Rectangle(
          extent={{2,54},{90,50}},
          lineColor={216,112,112},
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,54},{-4,32}},
          lineColor={216,112,112},
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32,60},{48,52},{64,60},{64,44},{48,52},{32,44},{32,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,2},{98,-2}},
          lineColor={105,149,214},
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,54},{-4,52}},
          lineColor={216,112,112},
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-3,2},{3,-2}},
          lineColor={105,149,214},
          lineThickness=0.5,
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid,
          origin={0,-25},
          rotation=90),
        Rectangle(
          extent={{-39,2},{39,-2}},
          lineColor={105,149,214},
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid,
          origin={100,-37},
          rotation=90),
        Text(
          extent={{-98,98},{100,82}},
          lineColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-28,-58},{-2,-86}},
          lineColor={105,149,214},
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-30,-62},{2,-62},{-6,-72},{2,-82},{-30,-82},{-30,-78},{-6,-78},
              {-10,-72},{-6,-66},{-30,-66},{-30,-62}},
          lineColor={216,112,112},
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid)}));
end PartialSteamGenerator;
