within TRANSFORM.Examples.GenericModular_PWR;
model GenericModule_standAlone
  extends BaseClasses.Partial_SubSystem(
    redeclare replaceable CS_Dummy CS,
    redeclare replaceable ED_Dummy ED,
    redeclare Data.Data_GenericModule data);
  package Medium = Modelica.Media.Water.StandardWater;
  package Medium_PHTS = Modelica.Media.Water.StandardWater;
//core.coolantSubchannel
final parameter SI.Density d_start_core_coolantSubchannel[:] = {729.99456787,707.68652344,683.89465332,658.36236572};
final parameter SI.Pressure p_start_core_coolantSubchannel[:] = {12911367.,12907437.,12903607.,12899882.};
final parameter SI.Temperature T_start_core_coolantSubchannel[:] = {569.07678223,579.30987549,588.94995117,597.87921143};
final parameter SI.SpecificEnthalpy h_start_core_coolantSubchannel[:] = {1317572.25,1374710.125,1431848.125,1488985.875};
//hotLeg
final parameter SI.Density d_start_hotLeg[:] = {658.2980957,658.20166016};
final parameter SI.Pressure p_start_hotLeg[:] = {12861758.,12810911.};
final parameter SI.Temperature T_start_hotLeg[:] = {597.85516357,597.82647705};
final parameter SI.SpecificEnthalpy h_start_hotLeg[:] = {1488930.125,1488878.625};
//coldLeg
final parameter SI.Density d_start_coldLeg[:] = {751.05932617};
final parameter SI.Pressure p_start_coldLeg[:] = {12936737.};
final parameter SI.Temperature T_start_coldLeg[:] = {558.34472656};
final parameter SI.SpecificEnthalpy h_start_coldLeg[:] = {1260434.125};
//STHX.tube
final parameter SI.Density d_start_STHX_tube[:] = {801.91125488,117.77983093,67.53452301,46.95209503,35.55274582,28.22073174,23.06417084,19.21644974,16.3672657,14.60087109};
final parameter SI.Pressure p_start_STHX_tube[:] = {3928153.5,3925242.75,3913008.75,3891694.,3861035.5,3820542.75,3769524.25,3707093.75,3632158.5,3500001.};
final parameter SI.Temperature T_start_STHX_tube[:] = {521.17053223,522.37127686,522.19030762,521.87188721,521.41033936,520.79528809,520.01159668,519.03967285,547.73358154,573.36859131};
final parameter SI.SpecificEnthalpy h_start_STHX_tube[:] = {1076191.5,1333470.,1550688.375,1770644.875,1997392.25,2233793.25,2481958.25,2743505.5,2901873.5,2978967.5};
//STHX.shell
final parameter SI.Density d_start_STHX_shell[:] = {662.02679443,669.76708984,682.17218018,693.54766846,704.05200195,713.84399414,723.09503174,732.00646973,742.28991699,750.97668457};
final parameter SI.Pressure p_start_STHX_shell[:] = {12810909.,12816239.,12819835.,12823497.,12827221.,12831002.,12834836.,12838720.,12842652.,12848634.};
final parameter SI.Temperature T_start_STHX_shell[:] = {596.58215332,593.97235107,589.5078125,585.11022949,580.78710938,576.52716064,572.29638672,568.02947998,562.8692627,558.31341553};
final parameter SI.SpecificEnthalpy h_start_STHX_shell[:] = {1480592.25,1463564.625,1435439.875,1408754.25,1383334.,1358952.,1335300.375,1311943.25,1284277.5,1260316.375};
//inletPlenum
final parameter SI.Density d_start_inletPlenum = 751.037;
final parameter SI.Pressure p_start_inletPlenum = 1.29207e+07;
final parameter SI.Temperature T_start_inletPlenum = 558.343;
final parameter SI.SpecificEnthalpy h_start_inletPlenum = 1.26043e+06;
//outletPlenum
final parameter SI.Density d_start_outletPlenum = 658.335;
final parameter SI.Pressure p_start_outletPlenum = 1.28884e+07;
final parameter SI.Temperature T_start_outletPlenum = 597.874;
final parameter SI.SpecificEnthalpy h_start_outletPlenum = 1.48899e+06;
//core.fuelModel.region_1
final parameter Real Ts_start_core_fuelModel_region_1[:,:] = {{833.46563721,844.07550049,853.94927979,862.88238525},{794.86474609,805.08477783,814.59460449,823.19750977},{687.40283203,696.56268311,705.08319092,712.78900146}};
//core.fuelModel.region_2
final parameter Real Ts_start_core_fuelModel_region_2[:,:] = {{687.40283203,696.56268311,705.08319092,712.78900146},{647.13977051,656.53381348,665.26824951,673.16430664},{606.20654297,615.85943604,624.82983398,632.93554688}};
//core.fuelModel.region_3
final parameter Real Ts_start_core_fuelModel_region_3[:,:] = {{606.20654297,615.85943604,624.82983398,632.93554688},{602.0279541,611.70294189,620.69366455,628.81744385},{598.11029053,607.80609131,616.81585693,624.95678711}};
//STHX.tubeWall
final parameter SI.Temperature T_start_STHX_tubeWall[:,:] = {{526.4765625,526.28808594,537.38659668,541.44897461,544.92095947,548.05151367,550.99615479,553.85308838,572.65716553,586.29663086},{536.44354248,537.79101562,547.02868652,551.18432617,554.93139648,558.46380615,561.90209961,565.32196045,579.52258301,589.61157227}};
//pressurizer
final parameter SI.Pressure p_start_pressurizer = 1.28109e+07;
final parameter SI.Length level_start_pressurizer = 1.18567;
final parameter SI.SpecificEnthalpy h_start_pressurizer = 1.47822e+06;
//pressurizer_tee
final parameter SI.Density d_start_pressurizer_tee = 658.202;
final parameter SI.Pressure p_start_pressurizer_tee = 1.28109e+07;
final parameter SI.Temperature T_start_pressurizer_tee = 597.826;
final parameter SI.SpecificEnthalpy h_start_pressurizer_tee = 1.48888e+06;
  TRANSFORM.Fluid.Volumes.SimpleVolume inletPlenum(redeclare package Medium =
        Medium_PHTS,
      redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder_specifyDiameter (
        length=data.length_inletPlenum,
        dimension=data.d_inletPlenum,
        angle=1.5707963267949),
    p_start=p_start_inletPlenum,
    T_start=T_start_inletPlenum)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-70})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface hotLeg(exposeState_a=false,
    redeclare package Medium = Medium_PHTS,
    p_a_start=data.p,
    m_flow_a_start=data.m_flow,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=data.d_hotLeg,
        length=data.length_hotLeg,
        nV=2,
        angle=1.5707963267949),
    ps_start=p_start_hotLeg,
    Ts_start=T_start_hotLeg,
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
        TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nRodFuel_assembly,
        nPins_nonFuel=data.nRodNonFuel_assembly,
        width_FtoF_inner=data.sizeAssembly*data.pitch_fuelRod,
        rs_outer={data.r_pellet_fuelRod,data.r_pellet_fuelRod + data.th_gap_fuelRod,data.r_outer_fuelRod},
        length=data.length_core,
        angle=1.5707963267949),
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
    Ts_start(displayUnit="degC") = T_start_core_coolantSubchannel,
    ps_start=p_start_core_coolantSubchannel,
    Ts_start_1(displayUnit="K") = Ts_start_core_fuelModel_region_1,
    Ts_start_2(displayUnit="K") = Ts_start_core_fuelModel_region_2,
    Ts_start_3(displayUnit="K") = Ts_start_core_fuelModel_region_3,
    fissionProductDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare record Data_DH =
        TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.decayHeat_11_TRACEdefault,
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_H3TeIXe_U235,
    Q_nominal=data.Q_total,
    Teffref_fuel=764.206,
    Teffref_coolant=583.392)
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-40})));
  TRANSFORM.Fluid.Volumes.SimpleVolume outletPlenum(
    redeclare package Medium = Medium_PHTS,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder_specifyDiameter (
        length=data.length_outletPlenum,
        dimension=data.d_outletPlenum,
        angle=1.5707963267949),
    p_start=p_start_outletPlenum,
    T_start=T_start_outletPlenum)
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
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=data.d_coldLeg,
        length=data.length_coldLeg,
        angle=-1.5707963267949,
        nSurfaces=2),
    ps_start=p_start_coldLeg,
    Ts_start=T_start_coldLeg,
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
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX (
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
    ps_start_shell=p_start_STHX_shell,
    Ts_start_shell=T_start_STHX_shell,
    ps_start_tube=p_start_STHX_tube,
    hs_start_tube=h_start_STHX_tube,
    Ts_wall_start=T_start_STHX_tubeWall)              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={24,2})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_to_port_b(
      redeclare package Medium = Medium, R=1*p_units/data.m_flow_steam)
    annotation (Placement(transformation(extent={{26,30},{46,50}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    T=T_start_STHX_tube[end],
    p=data.p_steam)
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=data.m_flow_steam,
    T=data.T_steam_cold)
    annotation (Placement(transformation(extent={{70,-42},{50,-22}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(
      m_flow_nominal=data.m_flow, redeclare package Medium = Medium_PHTS)
    annotation (Placement(transformation(extent={{0,-100},{-20,-80}})));
  TRANSFORM.Fluid.Volumes.ExpansionTank_1Port pressurizer(
    redeclare package Medium = Medium_PHTS,
    p_start=p_start_pressurizer,
    h_start=h_start_pressurizer,
    A=0.25*Modelica.Constants.pi*data.d_pressurizer^2,
    level_start=level_start_pressurizer)
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
    p_start=p_start_pressurizer_tee,
    T_start=T_start_pressurizer_tee)
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
  connect(resistance_to_port_b.port_b, boundary.ports[1])
    annotation (Line(points={{43,40},{50,40}}, color={0,127,255}));
  connect(boundary1.ports[1], STHX.port_a_tube)
    annotation (Line(points={{50,-32},{24,-32},{24,-8}}, color={0,127,255}));
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
  annotation (
    defaultComponentName="PHS",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Generic Modular PWR")}),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"));
end GenericModule_standAlone;
