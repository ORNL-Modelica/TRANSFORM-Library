within TRANSFORM.Examples.GenericModular_PWR;
model GenericModule

  extends BaseClasses.Partial_SubSystem_A(
    redeclare replaceable CS_Dummy CS,
    redeclare replaceable ED_Dummy ED,
    redeclare Data.Data_GenericModule data,
   replaceable package Medium = Modelica.Media.Water.StandardWater,
   port_a_nominal(
     p=dataInitial.p_start_STHX_tube[1],
     h=data.h_steam_cold,
     m_flow=data.m_flow_steam),
   port_b_nominal(p=data.p_steam, h=dataInitial.h_start_STHX_tube[end]));

  package Medium_PHTS = Modelica.Media.Water.StandardWater;

  parameter Data.DataInitial dataInitial;

  TRANSFORM.Fluid.Volumes.SimpleVolume inletPlenum(redeclare package Medium =
        Medium_PHTS,
      redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder_specifyDiameter
        (
        length=data.length_inletPlenum,
        dimension=data.d_inletPlenum,
        angle=1.5707963267949),
    p_start=dataInitial.p_start_inletPlenum,
    T_start=dataInitial.T_start_inletPlenum)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-70})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface hotLeg(exposeState_a=false,
    redeclare package Medium = Medium_PHTS,
    p_a_start=data.p,
    m_flow_a_start=data.m_flow,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data.d_hotLeg,
        length=data.length_hotLeg,
        nV=2,
        angle=1.5707963267949),
    ps_start=dataInitial.p_start_hotLeg,
    Ts_start=dataInitial.T_start_hotLeg,
    T_a_start=data.T_hot,
    exposeState_b=true)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,20})));
  TRANSFORM.Nuclear.CoreSubchannels.Regions_3 core(
    redeclare package Medium = Medium_PHTS,
    redeclare package Material_1 = TRANSFORM.Media.Solids.UO2,
    redeclare package Material_2 = TRANSFORM.Media.Solids.Helium,
    redeclare package Material_3 = TRANSFORM.Media.Solids.ZrNb_E125,
    nParallel=data.nAssembly,
    p_b_start(displayUnit="Pa"),
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly
        (
        nPins=data.nRodFuel_assembly,
        nPins_nonFuel=data.nRodNonFuel_assembly,
        width_FtoF_inner=data.sizeAssembly*data.pitch_fuelRod,
        rs_outer={data.r_pellet_fuelRod,data.r_pellet_fuelRod + data.th_gap_fuelRod,data.r_outer_fuelRod},
        length=data.length_core,
        angle=1.5707963267949),
    Q_nominal=data.Q_total,
    SigmaF_start=26,
    T_start_1=data.T_avg + 400,
    T_start_2=data.T_avg + 130,
    T_start_3=data.T_avg + 30,
    p_a_start(displayUnit="Pa") = data.p,
    T_a_start(displayUnit="K") = data.T_cold,
    T_b_start(displayUnit="K") = data.T_hot,
    m_flow_a_start=data.m_flow,
    exposeState_a=false,
    exposeState_b=false,
    Ts_start(displayUnit="degC") = dataInitial.T_start_core_coolantSubchannel,
    ps_start=dataInitial.p_start_core_coolantSubchannel,
    Ts_start_1(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_1,
    Ts_start_2(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_2,
    Ts_start_3(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_3,
    fissionProductDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare record Data_DH =
        TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.decayHeat_11_TRACEdefault,
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_H3TeIXe_U235,
    rho_input=CR_reactivity.y,
    Teffref_fuel=764.206,
    Teffref_coolant=583.392)
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-40})));

  TRANSFORM.Fluid.Volumes.SimpleVolume outletPlenum(
    redeclare package Medium = Medium_PHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder_specifyDiameter
        (
        length=data.length_outletPlenum,
        dimension=data.d_outletPlenum,
        angle=1.5707963267949),
    p_start=dataInitial.p_start_outletPlenum,
    T_start=dataInitial.T_start_outletPlenum)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-10})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface coldLeg(
    redeclare package Medium = Medium_PHTS,
    p_a_start=data.p,
    T_a_start=data.T_cold,
    m_flow_a_start=data.m_flow,
    exposeState_a=false,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data.d_coldLeg,
        length=data.length_coldLeg,
        angle=-1.5707963267949,
        nSurfaces=2),
    ps_start=dataInitial.p_start_coldLeg,
    Ts_start=dataInitial.T_start_coldLeg,
    exposeState_b=true)                                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-50})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX STHX(
    exposeState_b_shell=true,
    exposeState_b_tube=true,
    redeclare package Medium_tube = Medium_PHTS,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_3Region,
    p_a_start_shell=data.p,
    T_a_start_shell=data.T_hot,
    T_b_start_shell=data.T_cold,
    m_flow_a_start_shell=data.m_flow,
    p_a_start_tube=data.p_steam,
    use_Ts_start_tube=false,
    h_a_start_tube=data.h_steam_cold,
    h_b_start_tube=data.h_steam_hot,
    m_flow_a_start_tube=data.m_flow,
    redeclare package Medium_shell = Medium,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_i_shell=data.d_steamGenerator_shell_inner,
        D_o_shell=data.d_steamGenerator_shell_outer,
        length_shell=data.length_steamGenerator,
        nTubes=data.nTubes_steamGenerator,
        nV=10,
        dimension_tube=data.d_steamGenerator_tube_inner,
        length_tube=data.length_steamGenerator_tube,
        th_wall=data.th_steamGenerator_tube,
        nR=2,
        angle_shell=-1.5707963267949),
    ps_start_shell=dataInitial.p_start_STHX_shell,
    Ts_start_shell=dataInitial.T_start_STHX_shell,
    ps_start_tube=dataInitial.p_start_STHX_tube,
    hs_start_tube=dataInitial.h_start_STHX_tube,
    Ts_wall_start=dataInitial.T_start_STHX_tubeWall)              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={24,2})));

  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_to_port_b(
      redeclare package Medium = Medium, R=1*p_units/data.m_flow_steam)
    annotation (Placement(transformation(extent={{26,30},{46,50}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(
      m_flow_nominal=data.m_flow, redeclare package Medium = Medium_PHTS)
    annotation (Placement(transformation(extent={{0,-100},{-20,-80}})));
  TRANSFORM.Fluid.Volumes.ExpansionTank_1Port pressurizer(
    redeclare package Medium = Medium_PHTS,
    p_start=dataInitial.p_start_pressurizer,
    h_start=dataInitial.h_start_pressurizer,
    A=0.25*Modelica.Constants.pi*data.d_pressurizer^2,
    level_start=dataInitial.level_start_pressurizer)
    "pressurizer.Medium.bubbleEnthalpy(Medium.setSat_p(pressurizer.p_start))"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance teeTopressurizer(
      redeclare package Medium = Medium_PHTS, R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,60})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume pressurizer_tee(
    redeclare package Medium = Medium_PHTS,
    V=0.001,
    p_start=dataInitial.p_start_pressurizer_tee,
    T_start=dataInitial.T_start_pressurizer_tee)
    annotation (Placement(transformation(extent={{-16,34},{-4,46}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance tee_outlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,40})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance tee_inlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,40})));

  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow1(redeclare
      package Medium = Medium, m_flow_nominal=data.m_flow_steam,
    use_input=true)
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  TRANSFORM.Blocks.RealExpression CR_reactivity
    annotation (Placement(transformation(extent={{-54,128},{-42,140}})));
  Modelica.Blocks.Sources.RealExpression Q_total(y=core.kinetics.Q_total)
    annotation (Placement(transformation(extent={{-76,128},{-64,140}})));
  TRANSFORM.Fluid.Sensors.RelativeTemperature relativeTemperature(redeclare
      package Medium = Medium_PHTS, refPort_a=false) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-42})));

protected
  final parameter SI.Pressure p_units = 1;
equation

  connect(outletPlenum.port_a, core.port_b)
    annotation (Line(points={{-40,-16},{-40,-30}},        color={0,127,255}));
  connect(inletPlenum.port_b, core.port_a)
    annotation (Line(points={{-40,-64},{-40,-50}}, color={0,127,255}));
  connect(outletPlenum.port_b, hotLeg.port_a)
    annotation (Line(points={{-40,-4},{-40,10}}, color={0,127,255}));
  connect(STHX.port_b_shell, coldLeg.port_a)
    annotation (Line(points={{19.4,-8},{20,-8},{20,-40}}, color={0,127,255}));
  connect(STHX.port_b_tube, resistance_to_port_b.port_a)
    annotation (Line(points={{24,12},{24,40},{29,40}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, inletPlenum.port_a) annotation (Line(
        points={{-20,-90},{-40,-90},{-40,-76}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_a, coldLeg.port_b)
    annotation (Line(points={{0,-90},{20,-90},{20,-60}}, color={0,127,255}));
  connect(pressurizer.port, teeTopressurizer.port_b)
    annotation (Line(points={{-10,71.6},{-10,67}}, color={0,127,255}));
  connect(teeTopressurizer.port_a, pressurizer_tee.port_3)
    annotation (Line(points={{-10,53},{-10,46}}, color={0,127,255}));
  connect(pressurizer_tee.port_2, tee_outlet.port_a)
    annotation (Line(points={{-4,40},{3,40}}, color={0,127,255}));
  connect(tee_outlet.port_b, STHX.port_a_shell)
    annotation (Line(points={{17,40},{19.4,40},{19.4,12}}, color={0,127,255}));
  connect(hotLeg.port_b, tee_inlet.port_a)
    annotation (Line(points={{-40,30},{-40,40},{-37,40}}, color={0,127,255}));
  connect(tee_inlet.port_b, pressurizer_tee.port_1)
    annotation (Line(points={{-23,40},{-16,40}}, color={0,127,255}));

  connect(resistance_to_port_b.port_b, port_b)
    annotation (Line(points={{43,40},{100,40}}, color={0,127,255}));

  connect(STHX.port_a_tube, pump_SimpleMassFlow1.port_b)
    annotation (Line(points={{24,-8},{24,-40},{40,-40}}, color={0,127,255}));
  connect(pump_SimpleMassFlow1.port_a, port_a)
    annotation (Line(points={{60,-40},{100,-40}}, color={0,127,255}));
  connect(actuatorBus.reactivity_CR, CR_reactivity.u) annotation (Line(
      points={{30.1,100.1},{-58,100.1},{-58,134},{-55.2,134}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.Q_total, Q_total.y) annotation (Line(
      points={{-29.9,100.1},{-63.4,100.1},{-63.4,134}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(relativeTemperature.port_b, hotLeg.port_a) annotation (Line(points={{
          -66,-32},{-66,2},{-40,2},{-40,10}}, color={0,127,255}));
  connect(relativeTemperature.port_a, inletPlenum.port_a) annotation (Line(
        points={{-66,-52},{-66,-90},{-40,-90},{-40,-76}}, color={0,127,255}));
  connect(sensorBus.dT_core, relativeTemperature.T_rel) annotation (Line(
      points={{-29.9,100.1},{-90,100.1},{-90,-42},{-69.6,-42}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.m_flow_steam, pump_SimpleMassFlow1.in_m_flow) annotation (
     Line(
      points={{30.1,100.1},{50,100.1},{50,-32.7}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  annotation (
    defaultComponentName="PHS",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-15,5},{15,-5}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          origin={61,-41},
          rotation=360),
        Polygon(
          points={{62,-44},{58,-48},{74,-48},{70,-44},{62,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{60,-34},{72,-46}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),                                    Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Generic Modular PWR"),
        Rectangle(
          extent={{-0.492602,1.39701},{17.9804,-1.39699}},
          lineColor={0,0,0},
          origin={-28.0196,32.603},
          rotation=180,
          fillColor={230,0,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{0.9,1.1334},{12.3937,-1.1334}},
          lineColor={0,0,0},
          origin={-45.8666,30.3395},
          rotation=90,
          fillColor={230,0,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-1.81827,5.40665},{66.3684,-5.40665}},
          lineColor={0,0,0},
          origin={-22.5933,-44.1817},
          rotation=90,
          fillColor={240,215,26},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-1.54667,5},{56.453,-5}},
          lineColor={0,0,0},
          origin={-26.453,41},
          rotation=0,
          fillColor={230,0,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-1.28,5},{46.7196,-5}},
          lineColor={0,0,0},
          origin={-16.7196,-41},
          rotation=0,
          fillColor={240,215,26},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{10,-44},{6,-48},{22,-48},{18,-44},{10,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{8,-34},{20,-46}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{16,-37},{16,-43},{12,-40},{16,-37}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-57,64},{-35,41}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-55,61},{-38,51}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-55,51},{-38,43}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-1.17337,6},{42.8266,-6}},
          lineColor={0,0,0},
          origin={-22,3.17337},
          rotation=90,
          fillColor={230,0,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-46,-24},{2,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={240,215,26}),
        Ellipse(
          extent={{-46,16},{2,8}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={230,0,0}),
        Rectangle(
          extent={{-46,12},{2,-28}},
          lineColor={0,0,0},
          fillColor={200,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,12},{-38,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,12},{-30,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,12},{-22,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,12},{-14,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,12},{-6,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{-58,48},{-50,48},{-52,46},{-50,44},{-58,44}}, color={0,0,0}),
        Rectangle(
          extent={{-13,4},{13,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={230,0,0},
          origin={28,33},
          rotation=-90),
        Rectangle(
          extent={{-20,3},{20,-3}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward,
          origin={35,0},
          rotation=-90),
        Rectangle(
          extent={{-20,4},{20,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255},
          origin={42,0},
          rotation=-90),
        Rectangle(
          extent={{-0.693333,3.99999},{25.307,-4}},
          lineColor={0,0,0},
          origin={28,-45.307},
          rotation=90,
          fillColor={240,215,26},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{38,46},{76,34}},
          lineColor={0,0,0},
          fillColor={66,200,200},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-13,4},{13,-4}},
          lineColor={0,0,0},
          fillColor={66,200,200},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={42,33},
          rotation=90),
        Rectangle(
          extent={{-13,4},{13,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          origin={42,-33},
          rotation=-90),
        Rectangle(
          extent={{-20,4},{20,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,136,0},
          origin={28,0},
          rotation=-90),
        Polygon(
          points={{68,-37},{68,-43},{64,-40},{68,-37}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"));
end GenericModule;
