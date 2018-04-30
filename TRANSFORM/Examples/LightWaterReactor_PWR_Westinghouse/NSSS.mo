within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse;
model NSSS "Nuclear steam supply system"

  extends BaseClasses.Partial_SubSystem_A(
    replaceable package Medium = Modelica.Media.Water.StandardWater,
    allowFlowReversal=system.allowFlowReversal,
    redeclare replaceable CS_Default CS,
    redeclare replaceable ED_Default ED,
    port_a_nominal(
      p=data.p_shellSide+10e5,
      h=Medium.specificEnthalpy_pT(port_a_nominal.p,497),
      m_flow=data.m_flow_shellSide_total),
    port_b_nominal(p=data.p_shellSide, h=data.h_vsat),
    redeclare Data.Data_Basic data);

  package Medium_PHTS = Modelica.Media.Water.StandardWater
    "Primary heat transport system medium" annotation (Dialog(enable=false));

  Nuclear.CoreSubchannels.Regions_3 coreSubchannel(
    redeclare package Medium = Medium_PHTS,
    redeclare package Material_1 = Media.Solids.UO2,
    redeclare package Material_2 = Media.Solids.Helium,
    redeclare package Material_3 = Media.Solids.ZrNb_E125,
    exposeState_b=true,
    nParallel=data.nAssembly,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nRodFuel_assembly,
        nPins_nonFuel=data.nRodNonFuel_assembly,
        width_FtoF_inner=data.sizeAssembly*data.pitch_fuelRod,
        length=data.length_fuel,
        angle=1.5707963267949,
        rs_outer={data.r_pellet_fuelRod,data.r_pellet_fuelRod + data.th_gap_fuelRod,
            data.r_outer_fuelRod}),
    Ts_start_1(displayUnit="K"),
    Ts_start_2(displayUnit="K"),
    Ts_start_3(displayUnit="K"),
    p_a_start(displayUnit="Pa") = data.p_nominal,
    p_b_start(displayUnit="Pa"),
    Ts_start(displayUnit="K"),
    T_a_start(displayUnit="K") = data.T_core_inlet_nominal,
    T_b_start(displayUnit="K") = data.T_core_outlet_nominal,
    m_flow_a_start=data.m_flow_nominal,
    Q_nominal=data.Q_total_th,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_start_1=data.T_core_avg + 400,
    T_start_2=data.T_core_avg + 130,
    T_start_3=data.T_core_avg + 30,
    Teffref_fuel=978.463,
    Teffref_coolant=587.8) "-3.24e-5, -2.88e-4"
                             annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=90,
        origin={-60,-30})));

  Fluid.Volumes.SimpleVolume    core_outletPlenum(
    redeclare package Medium = Medium_PHTS,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data.length_outlet_plenum,
        crossArea=data.crossArea_outlet_plenum,
        angle=1.5707963267949),
    p_start=data.p_nominal,
    T_start=data.T_core_outlet_nominal)    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={-60,10})));
  Fluid.Volumes.SimpleVolume core_inletPlenum(
    redeclare package Medium = Medium_PHTS,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data.length_inlet_plenum,
        crossArea=data.crossArea_inlet_plenum,
        angle=1.5707963267949),
    p_start(displayUnit="Pa") = data.p_nominal,
    T_start(displayUnit="K") = data.T_core_inlet_nominal) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-60,-68})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                          DownComer(
    redeclare package Medium = Medium_PHTS,
    energyDynamics=system.energyDynamics,
    momentumDynamics=system.momentumDynamics,
    p_a_start(displayUnit="Pa") = data.p_nominal,
    p_b_start(displayUnit="Pa"),
    T_a_start(displayUnit="K") = data.T_core_inlet_nominal,
    T_b_start(displayUnit="K"),
    m_flow_a_start=data.m_flow_nominal,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data.crossArea_downcomer,
        length=data.length_downcomer,
        perimeter=data.perimeter_downcomer,
        angle=-1.5707963267949))           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={-40,-40})));
  Fluid.FittingsAndResistances.TeeJunctionVolume
                                            PressurizerHeader(
    redeclare package Medium = Medium_PHTS,
    p_start(displayUnit="Pa") = 15531745,
    T_start(displayUnit="K") = 595.1019,
    V=0.01)
    annotation (Placement(transformation(extent={{-32,48},{-24,56}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_toPzr(R=1,
      redeclare package Medium = Medium_PHTS) annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={-28,63})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_coreOutlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        origin={-60,-8.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_coreInlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-5.5,-5},{5.5,5}},
        rotation=90,
        origin={-60,-50.5})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_toHeader(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-48,52})));
  Fluid.Volumes.Pressurizer_withWall
                                 pressurizer(
    cp_wall=600,
    redeclare package Medium = Medium_PHTS,
    redeclare model BulkEvaporation =
        Fluid.Volumes.BaseClasses.BaseDrum.Evaporation.ConstantTimeDelay (tau=
            15),
    redeclare model BulkCondensation =
        Fluid.Volumes.BaseClasses.BaseDrum.Condensation.ConstantTimeDelay (tau=
            15),
    redeclare model MassTransfer_VL =
        Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface.ConstantMassTransportCoefficient
        (alphaD0=0.001),
    redeclare model HeatTransfer_VL =
        Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface.ConstantHeatTransferCoefficient
        (alpha0=100),
    redeclare model HeatTransfer_WL =
        Fluid.Volumes.BaseClasses.BaseDrum.HeatTransfer.ConstantHeatTransferCoefficient,
    redeclare model HeatTransfer_WV =
        Fluid.Volumes.BaseClasses.BaseDrum.HeatTransfer.ConstantHeatTransferCoefficient,
    redeclare model DrumType =
        Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes.SimpleCylinder (r_1=0.5*
            data.dimension_pzr, h_1=data.length_pzr),
    V_wall=Modelica.Constants.pi*((0.5*data.dimension_pzr + data.th_pzr)^2 - (0.5
        *data.dimension_pzr)^2)*data.length_pzr,
    rho_wall=7000,
    Vfrac_liquid_start=data.Vfrac_liquid_pzr,
    p_start(displayUnit="Pa") = data.p_nominal)
    annotation (Placement(transformation(extent={{-34,70},{-22,84}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature Temp_walLiquid(
                                                                        T=298.15)
    annotation (Placement(transformation(extent={{-10,73},{-18,81}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow liquidHeater(use_port=
        true) annotation (Placement(transformation(extent={{-46,68},{-40,74}})));
  Modelica.Blocks.Sources.Constant vaporHeaterSource(k=0)
    annotation (Placement(transformation(extent={{-59,79},{-51,87}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow vaporHeater(use_port=
        true) annotation (Placement(transformation(extent={{-46,80},{-40,86}})));
  Modelica.Fluid.Sources.MassFlowSource_h spray(
    h=400e3,
    m_flow=0,
    nPorts=1,
    redeclare package Medium = Medium_PHTS,
    use_m_flow_in=false)
    annotation (Placement(transformation(extent={{-40,86},{-34,92}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(
    h=relief.Medium.dewEnthalpy(relief.Medium.setSat_p(system.p_start)),
    nPorts=1,
    redeclare package Medium = Medium_PHTS)
    annotation (Placement(transformation(extent={{-16,86},{-22,92}})));
  inner Fluid.System         system(
    m_flow_start=4712,
    p_start(displayUnit="MPa") = 15500000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=565.15)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_SGtubeOutlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        origin={24,-26.5},
        extent={{5.5,-5},{-5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_SGtubeInlet(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        origin={24,24.5},
        extent={{5.5,-5},{-5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_SGshellInlet(
      redeclare package Medium = Medium, R=1*p_units/data.m_flow_shellSide_total)
    annotation (Placement(transformation(
        origin={36,-26.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_SGshellOutlet(
      redeclare package Medium = Medium, R=1*p_units/data.m_flow_shellSide_total)
    annotation (Placement(transformation(
        origin={36,24.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  Fluid.Volumes.SimpleVolume    SG_InletPlenum(
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_nominal,
    T_start=data.T_core_outlet_nominal,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1))
                                           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={24,42})));
  Fluid.Volumes.SimpleVolume    SG_OutletPlenum(
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_nominal,
    T_start=data.T_core_inlet_nominal,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1))
                                           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={24,-50})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                Steam_OutletPipe(
    p_a_start(displayUnit="Pa") = 5.8e6,
    p_b_start(displayUnit="Pa"),
    use_Ts_start=false,
    redeclare package Medium = Medium,
    h_a_start=2953664,
    h_b_start=2953630,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=3.776),
    momentumDynamics=system.momentumDynamics,
    m_flow_a_start=data.m_flow_shellSide_total)
                       annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={74,40})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                Steam_InletPipe(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="Pa") = 6.1856e+06,
    p_b_start(displayUnit="Pa") = 6.1856e+06,
    T_a_start(displayUnit="K") = 497.0025,
    T_b_start(displayUnit="K") = 497.0025,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=3.776, nV=2),
    exposeState_b=true,
    energyDynamics=system.energyDynamics,
    momentumDynamics=system.momentumDynamics,
    m_flow_a_start=data.m_flow_shellSide_total)
                                           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={74,-40})));

  Fluid.Sensors.Temperature          T_Core_Inlet(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-68,-40},{-76,-48}})));
  Fluid.Sensors.Temperature          T_Core_Outlet(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-68,-20},{-76,-12}})));

  Modelica.Blocks.Sources.RealExpression p_pressurizer(y=pressurizer.drum2Phase.p)
    "pressurizer pressure"
    annotation (Placement(transformation(extent={{-96,128},{-84,140}})));
  Modelica.Blocks.Sources.RealExpression W_balance
    "Electricity loss/gain not accounted for in connections (e.g., heating/cooling, pumps, etc.) [W]"
    annotation (Placement(transformation(extent={{-96,118},{-84,130}})));
  Modelica.Blocks.Sources.RealExpression FuelConsumption(y=(1 + 0.169)*
        Q_total.y/(200*1.6e-13*6.022e23/0.235))
    "Approximate nuclear fuel consumption [kg/s]"
    annotation (Placement(transformation(extent={{-96,108},{-84,120}})));

  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance res_fromHeader(
      redeclare package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-14,52})));
  HeatExchangers.GenericDistributed_HX    steamGenerator(
    redeclare package Material_tubeWall = Media.Solids.Inconel690,
    energyDynamics={system.energyDynamics,system.energyDynamics,system.energyDynamics},
    exposeState_b_shell=true,
    exposeState_b_tube=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nV=20,
        nR=3,
        D_o_shell=data.diameter_inner_lowerShell,
        length_shell=data.length_lowerShell,
        nTubes=data.nTubes,
        angle_shell=1.5707963267949,
        dimension_tube=data.diameter_inner_SGtube,
        length_tube=data.length_SGtube,
        th_wall=data.th_SGtube),
    redeclare package Medium_shell = Medium,
    redeclare package Medium_tube = Medium_PHTS,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_3Region,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    p_a_start_shell(displayUnit="bar") = data.p_shellSide,
    p_b_start_shell(displayUnit="bar"),
    Ts_start_shell(displayUnit="K"),
    T_a_start_shell(displayUnit="K"),
    T_b_start_shell(displayUnit="K"),
    use_Ts_start_shell=false,
    p_a_start_tube(displayUnit="Pa") = data.p_nominal,
    p_b_start_tube(displayUnit="Pa"),
    T_a_start_tube=data.T_core_outlet_nominal,
    T_b_start_tube=data.T_core_inlet_nominal,
    m_flow_a_start_tube=data.m_flow_nominal,
    nParallel=data.nSG,
    m_flow_a_start_shell=data.m_flow_shellSide_total,
    h_a_start_shell=data.h_lsat,
    h_b_start_shell=data.h_vsat - 1e5)              annotation (Placement(
        transformation(
        extent={{-13,-11},{13,11}},
        rotation=-90,
        origin={30,1})));

  Blocks.RealExpression CR_reactivity
    annotation (Placement(transformation(extent={{-54,128},{-42,140}})));
  Modelica.Blocks.Sources.RealExpression Q_total(y=coreSubchannel.reactorKinetics.Q_total)
    "total thermal power"
    annotation (Placement(transformation(extent={{-76,118},{-64,130}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface coldleg(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = data.p_nominal,
    p_b_start(displayUnit="Pa"),
    T_a_start(displayUnit="K") = data.T_core_inlet_nominal,
    T_b_start(displayUnit="K"),
    m_flow_a_start=data.m_flow_nominal,
    exposeState_b=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data.dimension_coldleg,
        length=data.length_coldleg,
        nV=2)) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={-16,-22})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface hotLeg(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = data.p_nominal,
    p_b_start(displayUnit="Pa"),
    T_a_start(displayUnit="K") = data.T_core_inlet_nominal,
    T_b_start(displayUnit="K"),
    m_flow_a_start=data.m_flow_nominal,
    exposeState_b=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data.dimension_hotleg,
        length=data.length_hotleg,
        nV=2)) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={2,52})));
  Fluid.FittingsAndResistances.SpecifiedResistance res_coldLeg(redeclare
      package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        origin={0,-22.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=180)));
  Fluid.FittingsAndResistances.SpecifiedResistance res_hotLeg(redeclare package
      Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal) annotation (
      Placement(transformation(
        origin={20,52.5},
        extent={{5.5,-5},{-5.5,5}},
        rotation=180)));

protected
  final parameter SI.Pressure p_units = 1;
public
  Fluid.FittingsAndResistances.SpecifiedResistance res_downcomer(redeclare
      package Medium = Medium_PHTS, R=1*p_units/data.m_flow_nominal)
    annotation (Placement(transformation(
        origin={-32,-22.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=180)));
  Fluid.Machines.Pump_SimpleMassFlow
                      pump(m_flow_nominal=data.m_flow_nominal, redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={4,-42})));
equation

  connect(res_toPzr.port_b, PressurizerHeader.port_3) annotation (Line(points={{
          -28,59.5},{-28,59.5},{-28,56}}, color={0,0,255}));
  connect(coreSubchannel.port_a, res_coreInlet.port_b)
    annotation (Line(points={{-60,-37},{-60,-46.65}}, color={0,127,255}));
  connect(PressurizerHeader.port_1, res_toHeader.port_b)
    annotation (Line(points={{-32,52},{-44.5,52}}, color={0,127,255}));
  connect(Temp_walLiquid.port,pressurizer. heatTransfer_wall)
    annotation (Line(points={{-18,77},{-18,77},{-22,77}}, color={191,0,0}));
  connect(pressurizer.surgePort, res_toPzr.port_a)
    annotation (Line(points={{-28,70},{-28,66.5}}, color={0,127,255}));
  connect(vaporHeater.port,pressurizer. vaporHeater) annotation (Line(points={{-40,
          83},{-38,83},{-38,79.8},{-34,79.8}}, color={191,0,0}));
  connect(liquidHeater.port,pressurizer. liquidHeater) annotation (Line(points={
          {-40,71},{-38,71},{-38,74},{-34,74},{-34,74.2}}, color={191,0,0}));
  connect(pressurizer.sprayPort,spray. ports[1]) annotation (Line(points={{-31.6,
          84},{-32,84},{-32,89},{-34,89}}, color={0,127,255}));
  connect(pressurizer.reliefPort,relief. ports[1]) annotation (Line(points={{-24.4,
          84},{-24,84},{-24,89},{-22,89}}, color={0,127,255}));
  connect(Steam_OutletPipe.port_a, res_SGshellOutlet.port_b)
    annotation (Line(points={{68,40},{36,40},{36,28.35}}, color={0,127,255}));
  connect(Steam_InletPipe.port_b, res_SGshellInlet.port_a) annotation (Line(
        points={{68,-40},{36,-40},{36,-30.35}}, color={0,127,255}));
  connect(Steam_OutletPipe.port_b,port_b)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(Steam_InletPipe.port_a,port_a)
    annotation (Line(points={{80,-40},{100,-40}}, color={0,127,255}));
  connect(sensorBus.p_pressurizer, p_pressurizer.y) annotation (Line(
      points={{-29.9,100.1},{-80,100.1},{-80,134},{-83.4,134}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Inlet, T_Core_Inlet.T) annotation (Line(
      points={{-29.9,100.1},{-98,100.1},{-98,-44},{-76.4,-44}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Outlet, T_Core_Outlet.T) annotation (Line(
      points={{-29.9,100.1},{-98,100.1},{-98,-16},{-76.4,-16}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(PressurizerHeader.port_2, res_fromHeader.port_a)
    annotation (Line(points={{-24,52},{-17.5,52}}, color={0,127,255}));

  connect(coreSubchannel.port_b, res_coreOutlet.port_a)
    annotation (Line(points={{-60,-23},{-60,-12.35}}, color={0,127,255}));
  connect(T_Core_Outlet.port, res_coreOutlet.port_a) annotation (Line(points={{-72,
          -20},{-60,-20},{-60,-12.35}}, color={0,127,255}));
  connect(T_Core_Inlet.port, coreSubchannel.port_a) annotation (Line(points={{-72,-40},
          {-60,-40},{-60,-37}},          color={0,127,255}));
  connect(vaporHeaterSource.y, vaporHeater.Q_flow_ext) annotation (Line(points=
          {{-50.6,83},{-47.3,83},{-47.3,83},{-44.2,83}}, color={0,0,127}));
  connect(actuatorBus.Q_flow_liquidHeater, liquidHeater.Q_flow_ext) annotation (
     Line(
      points={{30.1,100.1},{30.1,100.1},{-2,100.1},{-2,102},{-100,102},{-100,71},
          {-44.2,71}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.Q_total, Q_total.y) annotation (Line(
      points={{-29.9,100.1},{-29.9,100.1},{-60,100.1},{-60,124},{-63.4,124}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.reactivity_ControlRod, CR_reactivity.u) annotation (Line(
      points={{30.1,100.1},{-2,100.1},{-2,102},{-55.2,102},{-55.2,134}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(core_outletPlenum.port_a, res_coreOutlet.port_b)
    annotation (Line(points={{-60,6.4},{-60,-4.65}}, color={0,127,255}));
  connect(res_coreInlet.port_a, core_inletPlenum.port_b)
    annotation (Line(points={{-60,-54.35},{-60,-64.4}}, color={0,127,255}));
  connect(DownComer.port_b, core_inletPlenum.port_a) annotation (Line(points={{-40,
          -46},{-40,-80},{-60,-80},{-60,-71.6}}, color={0,127,255}));
  connect(core_outletPlenum.port_b, res_toHeader.port_a) annotation (Line(
        points={{-60,13.6},{-60,52},{-51.5,52}}, color={0,127,255}));
  connect(SG_OutletPlenum.port_a, res_SGtubeOutlet.port_b)
    annotation (Line(points={{24,-46.4},{24,-30.35}}, color={0,127,255}));
  connect(SG_InletPlenum.port_b, res_SGtubeInlet.port_a)
    annotation (Line(points={{24,38.4},{24,28.35}}, color={0,127,255}));
  connect(res_downcomer.port_b, DownComer.port_a) annotation (Line(points={{-35.85,
          -22.5},{-40,-22.5},{-40,-34}}, color={0,127,255}));
  connect(res_SGshellInlet.port_b, steamGenerator.port_a_shell) annotation (
      Line(points={{36,-22.65},{36,-12},{35.06,-12}}, color={0,127,255}));
  connect(res_SGshellOutlet.port_a, steamGenerator.port_b_shell) annotation (
      Line(points={{36,20.65},{36,14},{35.06,14}}, color={0,127,255}));
  connect(res_SGtubeOutlet.port_a, steamGenerator.port_b_tube) annotation (Line(
        points={{24,-22.65},{24,-16},{30,-16},{30,-12}}, color={0,127,255}));
  connect(res_SGtubeInlet.port_b, steamGenerator.port_a_tube) annotation (Line(
        points={{24,20.65},{24,18},{30,18},{30,14}}, color={0,127,255}));
  connect(res_fromHeader.port_b, hotLeg.port_a)
    annotation (Line(points={{-10.5,52},{-4,52}}, color={0,127,255}));
  connect(hotLeg.port_b, res_hotLeg.port_a) annotation (Line(points={{8,52},{12,
          52},{12,52.5},{16.15,52.5}}, color={0,127,255}));
  connect(res_hotLeg.port_b, SG_InletPlenum.port_a) annotation (Line(points={{23.85,
          52.5},{24,52.5},{24,45.6}}, color={0,127,255}));
  connect(pump.port_a, SG_OutletPlenum.port_b) annotation (Line(points={{4,-52},
          {4,-60},{24,-60},{24,-53.6}}, color={0,127,255}));
  connect(res_downcomer.port_a, coldleg.port_b) annotation (Line(points={{-28.15,
          -22.5},{-25.075,-22.5},{-25.075,-22},{-22,-22}}, color={0,127,255}));
  connect(coldleg.port_a, res_coldLeg.port_b) annotation (Line(points={{-10,-22},
          {-6,-22},{-6,-22.5},{-3.85,-22.5}}, color={0,127,255}));
  connect(res_coldLeg.port_a, pump.port_b) annotation (Line(points={{3.85,-22.5},
          {3.85,-26.25},{4,-26.25},{4,-32}}, color={0,127,255}));
  annotation (
    defaultComponentName="PHS",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Westinghouse: 4-Loop PWR"),
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
          points={{-2,38},{-6,34},{10,34},{6,38},{-2,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-4,48},{8,36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,45},{0,39},{4,42},{0,45}},
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
          extent={{-15,6},{15,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          origin={61,-40},
          rotation=360),
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
          rotation=-90)}));
end NSSS;
