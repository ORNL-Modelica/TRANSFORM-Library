within TRANSFORM.Examples.LightWaterSmallModularReactor;
model IRIS

  extends BaseClasses.Partial_SubSystem_A(
    replaceable package Medium = Modelica.Media.Water.StandardWater,
    allowFlowReversal=system.allowFlowReversal,
    redeclare replaceable CS_Default CS,
    redeclare replaceable ED_Default ED,
    port_a_nominal(
      p=6.19e6,
      T=497,
      m_flow=502.8),
    port_b_nominal(p=5.8e6, T=591),
    redeclare Data.IRIS_PHS data);

  package Medium_PHTS = Modelica.Media.Water.StandardWater
    "Primary heat transport system medium" annotation (Dialog(enable=false));

  Nuclear.CoreSubchannels.Regions_3 coreSubchannel(
    Ts_start_3(displayUnit="K") = [{coreSubchannel.Ts_start_2[end, 1]},{
      coreSubchannel.Ts_start_2[end, 2]},{coreSubchannel.Ts_start_2[end, 3]},{
      coreSubchannel.Ts_start_2[end, 4]}; 588.673217773438,598.278564453125,607.177856445313,
      615.421997070313; 583.928039550781,593.558532714844,602.48095703125,610.746276855469],
    Ts_start_2(displayUnit="K") = [{coreSubchannel.Ts_start_1[end, 1]},{
      coreSubchannel.Ts_start_1[end, 2]},{coreSubchannel.Ts_start_1[end, 3]},{
      coreSubchannel.Ts_start_1[end, 4]}; 645.326904296875,654.579406738281,663.157775878906,
      671.109558105469; 593.718627929688,603.297302246094,612.172241210938,620.393920898438],
    Ts_start_1(displayUnit="K") = [855.985778808594,866.50341796875,876.264709472656,
      885.321228027344; 849.067749023438,859.516784667969,869.214233398438,878.211303710938;
      828.583129882813,838.829895019531,848.339050292969,857.160949707031; 795.317565917969,
      805.238525390625,814.444396972656,822.984252929688; 750.507690429688,759.9951171875,
      768.797485351563,776.962097167969; 695.743530273438,704.709289550781,713.0263671875,
      720.73974609375],
    Lambda=16e-6,
    T_start_1=system.T_start + 225,
    T_start_2=system.T_start + 50,
    T_start_3=system.T_start + 20,
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15700586,
    p_b_start(displayUnit="Pa") = 15655919,
    T_a_start(displayUnit="K") = 557.0997,
    T_b_start(displayUnit="K") = 595.1576,
    Ts_start(displayUnit="K") = {567.265808105469,577.039306640625,586.362365722656,
      595.158447265625},
    alpha_fuel=-3.24e-5,
    alpha_coolant=-2.88e-4,
    redeclare package Material_1 = Media.Solids.UO2,
    redeclare package Material_2 = Media.Solids.Helium,
    redeclare package Material_3 = Media.Solids.ZrNb_E125,
    m_flow_a_start=system.m_flow_start,
    energyDynamics=system.energyDynamics,
    energyDynamics_fuel=system.energyDynamics,
    exposeState_b=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Generic (
        nRs={6,3,3},
        length=4.27,
        dheight=coreSubchannel.geometry.length,
        rs_outer={0.5*0.0081915,0.5*0.0083566,0.5*0.0095},
        nPins=23496,
        nV=4,
        crossArea=2.726627,
        perimeter=767.6466),
    Teffref_fuel=786.152,
    Teffref_coolant=581.457) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=90,
        origin={-60,-58})));

  Fluid.Pipes.GenericPipe       Core_OutletPlenum(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15598719,
    p_b_start(displayUnit="Pa") = 15595051,
    T_a_start(displayUnit="K") = 595.1398,
    T_b_start(displayUnit="K") = 595.1296,
    energyDynamics=system.energyDynamics,
    momentumDynamics=system.momentumDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=1.3,
        length=0.55,
        dheight=Core_OutletPlenum.geometry.length))
                                           annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={-60,-20})));
  Fluid.Volumes.MixingVolume          LowerPlenum(
    redeclare package Medium = Medium_PHTS,
    p_start(displayUnit="Pa") = 15777586,
    T_start(displayUnit="K") = 557.1060,
    nPorts_a=1,
    nPorts_b=1,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=14.83))
    annotation (Placement(transformation(extent={{-24,-78},{-36,-90}})));
  Fluid.Pipes.GenericPipe DownComer(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15734121,
    p_b_start(displayUnit="Pa") = 15777586,
    T_a_start(displayUnit="K") = 557.0912,
    T_b_start(displayUnit="K") = 557.1060,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=3.3,
        crossArea=23.52,
        length=5.85,
        roughness=1e-6,
        dheight=-DownComer.geometry.length),
    momentumDynamics=system.momentumDynamics)
                                           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={0,-70})));
  Fluid.Pipes.GenericPipe       LowerRiser(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15595051,
    p_b_start(displayUnit="Pa") = 15560693,
    T_a_start(displayUnit="K") = 595.1377,
    T_b_start(displayUnit="K") = 595.1115,
    energyDynamics=system.energyDynamics,
    momentumDynamics=system.momentumDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=0.312,
        crossArea=3.61,
        length=3.63 + 1.53,
        roughness=1e-6,
        dheight=LowerRiser.geometry.length))
                                           annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={-60,0})));
  Fluid.Pipes.GenericPipe UpperRiser(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15560693,
    p_b_start(displayUnit="Pa") = 15531747,
    T_a_start(displayUnit="K") = 595.1183,
    T_b_start(displayUnit="K") = 595.1019,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=1.296,
        crossArea=5.59,
        length=4.37,
        roughness=1e-6,
        dheight=UpperRiser.geometry.length),
    energyDynamics=system.energyDynamics,
    momentumDynamics=system.momentumDynamics) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={-60,20})));
  Fluid.Volumes.MixingVolume          ChargingMixerVolume(
    redeclare package Medium = Medium_PHTS,
    p_start(displayUnit="Pa") = 15531747,
    T_start(displayUnit="K") = 595.1019,
    nPorts_b=1,
    nPorts_a=1,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1.5))
                                         annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-60,40})));
  Fluid.FittingsAndResistances.TeeJunctionVolume
                                            PressurizerHeader(
    V=38.73,
    redeclare package Medium = Medium_PHTS,
    p_start(displayUnit="Pa") = 15531745,
    T_start(displayUnit="K") = 595.1019,
    energyDynamics=system.energyDynamics)
    annotation (Placement(transformation(extent={{-32,48},{-24,56}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance ToPressurizer_PressureDrop(R=1, redeclare
      package Medium = Medium_PHTS) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={-28,63})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance Core_OutletPressureDrop(R=5.2*11000/(8*589),
      redeclare package Medium = Medium_PHTS) annotation (Placement(
        transformation(
        origin={-60,-40.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance Core_InletPressureDrop(R=7*11000/(8*589),
      redeclare package Medium = Medium_PHTS) annotation (Placement(
        transformation(
        extent={{-5.5,-5},{5.5,5}},
        rotation=90,
        origin={-60,-74.5})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance ToHeader_PressureDrop(R=1/(5*589), redeclare
      package Medium = Medium_PHTS) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-48,52})));
  Fluid.Volumes.Pressurizer_withWall
                                 pressurizer(
    cp_wall=600,
    rho_wall=7000,
    V_wall=2/3*pi*((3.105 + 0.14)^3 - 3.105^3),
    V_total=pi*1.596^2*1.109 + pi*3.105^2*0.19 + 2/3*pi*3.105^3,
    redeclare package Medium = Medium_PHTS,
    Vfrac_liquid_start=0.3495,
    p_start(displayUnit="Pa") = 15521780,
    redeclare model DrumType =
        Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes.Integral (
        r_1=1.596,
        r_2=3.105,
        r_3=3.105,
        h_1=1.109,
        h_2=0.19),
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
        Fluid.Volumes.BaseClasses.BaseDrum.HeatTransfer.ConstantHeatTransferCoefficient)
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
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance SG_OutletPressureDrop(R=0.7*(15642500 - (15644200
         - 750*9.81*0.3))/(8*589), redeclare package Medium = Medium_PHTS)
    annotation (Placement(transformation(
        origin={46,-26.5},
        extent={{5.5,-5},{-5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance SG_InletPressureDrop(R=0.7*((15659500 + 666*9.81
        *0.3) - 15660700)/(8*589), redeclare package Medium = Medium_PHTS)
    annotation (Placement(transformation(
        origin={46,24.5},
        extent={{5.5,-5},{-5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance Steam_HelicalCoilInletPressureDrop(R=1e5/502.8,
      redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={58,-26.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance Steam_HelicalCoilOutletPressureDrop(R=1e5/502.8,
      redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={58,24.5},
        extent={{-5.5,-5},{5.5,5}},
        rotation=90)));
  Fluid.Pipes.GenericPipe       SG_InletPlenum(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15675945,
    p_b_start(displayUnit="Pa") = 15677931,
    T_a_start(displayUnit="K") = 595.1891,
    T_b_start(displayUnit="K") = 595.0252,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=3.776,
        length=0.3,
        roughness=1e-6,
        dheight=-SG_InletPlenum.geometry.length,
        nV=2),
    exposeState_b=true,
    momentumDynamics=system.momentumDynamics)
                                           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={46,42})));
  Fluid.Pipes.GenericPipe       SG_OutletPlenum(
    redeclare package Medium = Medium_PHTS,
    p_a_start(displayUnit="Pa") = 15731892,
    p_b_start(displayUnit="Pa") = 15734121,
    T_a_start(displayUnit="K") = 557.0905,
    T_b_start(displayUnit="K") = 557.1024,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=3.776,
        length=0.3,
        roughness=1e-6,
        dheight=-SG_OutletPlenum.geometry.length),
    momentumDynamics=system.momentumDynamics)
                                           annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={46,-50})));
  Fluid.Pipes.GenericPipe       Steam_OutletPipe(
    p_a_start(displayUnit="Pa") = 5.8e6,
    p_b_start(displayUnit="Pa"),
    use_Ts_start=false,
    m_flow_a_start=502.8,
    redeclare package Medium = Medium,
    h_a_start=2953664,
    h_b_start=2953630,
    energyDynamics=system.energyDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=3.776),
    momentumDynamics=system.momentumDynamics)
                       annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={74,40})));
  Fluid.Pipes.GenericPipe       Steam_InletPipe(
    m_flow_a_start=502.8,
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
    momentumDynamics=system.momentumDynamics)
                                           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={74,-40})));

  Fluid.Sensors.Temperature          T_Core_Inlet(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-68,-68},{-76,-76}})));
  Fluid.Sensors.Temperature          T_Core_Outlet(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-68,-48},{-76,-40}})));

  Modelica.Blocks.Sources.RealExpression p_pressurizer(y=pressurizer.drum2Phase.p)
    "pressurizer pressure"
    annotation (Placement(transformation(extent={{-96,128},{-84,140}})));
  Modelica.Blocks.Sources.RealExpression W_balance(y=nFlow.nParallel*pump.W +
        liquidHeater.Q_flow)
    "Electricity loss/gain not accounted for in connections (e.g., heating/cooling, pumps, etc.) [W]"
    annotation (Placement(transformation(extent={{-96,118},{-84,130}})));
  Modelica.Blocks.Sources.RealExpression FuelConsumption(y=(1 + 0.169)*
        coreSubchannel.reactorKinetics.Q_total/(200*1.6e-13*6.022e23/0.235))
    "Approximate nuclear fuel consumption [kg/s]"
    annotation (Placement(transformation(extent={{-96,108},{-84,120}})));
  Fluid.Machines.Pump pump(
    redeclare package Medium = Medium,
    redeclare model FlowChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PerformanceCurve
        (V_flow_curve={0,0.8728,1.5*0.8728}, head_curve={2*21.7693,21.7693,0}),
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant
        (eta_constant=0.8),
    m_flow_nominal=system.m_flow_start/8,
    d_nominal=675,
    dp_nominal=157 - 155,
    use_T_start=false,
    h_start=1.46505e6,
    m_flow_start=pump.m_flow_nominal,
    p_a_start(displayUnit="bar") = 15500000,
    use_port=true)
    annotation (Placement(transformation(extent={{8,42},{28,62}})));

  Fluid.Pipes.parallelFlow nFlow(redeclare package Medium = Medium, nParallel=8)
    annotation (Placement(transformation(extent={{-4,48},{2,56}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance ToHeader_PressureDrop1(
                                                                                   R=1/(5*589), redeclare
      package Medium = Medium_PHTS) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-14,52})));
  Fluid.Pipes.parallelFlow nFlow1(redeclare package Medium = Medium, nParallel=
        nFlow.nParallel)
    annotation (Placement(transformation(extent={{38,48},{32,56}})));
  HeatExchangers.GenericDistributed_HX               steamGenerator(
    nParallel=8,
    use_Ts_start_tube=false,
    p_b_start_tube(displayUnit="Pa") = 5.9e6,
    redeclare package Medium_shell = Medium_PHTS,
    redeclare package Medium_tube = Medium,
    p_a_start_tube(displayUnit="Pa") = 6.0856e+06,
    h_a_start_tube=962463,
    T_a_start_shell(displayUnit="K") = 595.1901,
    T_b_start_shell(displayUnit="K") = 557.0911,
    Ts_start_shell(displayUnit="K") = {595.025085449219,594.724182128906,594.155090332031,
      593.082824707031,591.095886230469,588.496643066406,584.942443847656,581.663757324219,
      578.658508300781,575.916442871094,573.423217773438,571.162841796875,569.118530273438,
      567.2734375,565.611083984375,564.115295410156,562.769714355469,561.558288574219,
      559.920471191406,557.090515136719},
    h_b_start_tube=2953664,
    hs_start_tube={1099128,1178831.375,1238086.375,1304201.875,1378077.375,1460663.625,
        1552953.75,1656019.125,1771025.625,1899240.25,2042028.75,2200840.5,2377157.25,
        2572314,2718030,2831324.75,2893237.75,2926355.75,2943995.25,2953664},
    redeclare package Material_tubeWall = Media.Solids.Inconel690,
    energyDynamics={system.energyDynamics,system.energyDynamics,system.energyDynamics},
    exposeState_b_shell=true,
    exposeState_b_tube=true,
    m_flow_a_start_tube=502.8,
    p_a_start_shell(displayUnit="bar") = 15677399,
    p_b_start_shell(displayUnit="bar") = 15732247,
    m_flow_a_start_shell=system.m_flow_start,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Alphas_TwoPhase_3Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (
        Nus0=
            HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.Nu_Grimison_FlowAcrossTubeBanks(
            steamGenerator.shell.heatTransfer.Res,
            steamGenerator.shell.heatTransfer.Prs,
            steamGenerator.geometry.dimensions_tube + 2*steamGenerator.geometry.ths_wall,
            1.25*(steamGenerator.geometry.dimensions_tube + 2*steamGenerator.geometry.ths_wall),
            1.25*(steamGenerator.geometry.dimensions_tube + 2*steamGenerator.geometry.ths_wall)),
        use_DefaultDimension=false,
        dimensions0=steamGenerator.geometry.dimensions_tube + 2*steamGenerator.geometry.ths_wall),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_i_shell=0.61,
        D_o_shell=1.64,
        nV=20,
        nTubes=750,
        nR=3,
        dheight_shell=-steamGenerator.geometry.length_shell,
        dimension_tube=0.01324,
        length_tube=32,
        th_wall=0.00211,
        length_shell=7.9,
        surfaceArea_tube={Modelica.Constants.pi*steamGenerator.geometry.perimeter_tube
            *steamGenerator.geometry.length_tube}))
    annotation (Placement(transformation(extent={{13,11},{-13,-11}},
        rotation=-90,
        origin={52,1})));

  Modelica.Blocks.Sources.RealExpression Q_total(y=coreSubchannel.reactorKinetics.Q_total)
    "total thermal power"
    annotation (Placement(transformation(extent={{-76,118},{-64,130}})));
  Blocks.RealExpression CR_reactivity
    annotation (Placement(transformation(extent={{-54,128},{-42,140}})));
equation

  connect(LowerRiser.port_a,Core_OutletPlenum. port_b)
    annotation (Line(points={{-60,-6},{-60,-14}}, color={0,127,255}));
  connect(UpperRiser.port_a,LowerRiser. port_b)
    annotation (Line(points={{-60,14},{-60,6}}, color={0,127,255}));
  connect(ToPressurizer_PressureDrop.port_b,PressurizerHeader. port_3)
    annotation (Line(points={{-28,59.5},{-28,59.5},{-28,56}},
                                                          color={0,0,255}));
  connect(coreSubchannel.port_a,Core_InletPressureDrop. port_b)
    annotation (Line(points={{-60,-65},{-60,-70.65}},
                                                   color={0,127,255}));
  connect(PressurizerHeader.port_1,ToHeader_PressureDrop. port_b)
    annotation (Line(points={{-32,52},{-44.5,52}},
                                                 color={0,127,255}));
  connect(Temp_walLiquid.port,pressurizer. heatTransfer_wall)
    annotation (Line(points={{-18,77},{-18,77},{-22,77}}, color={191,0,0}));
  connect(pressurizer.surgePort,ToPressurizer_PressureDrop. port_a)
    annotation (Line(points={{-28,70},{-28,66.5}},
                                                 color={0,127,255}));
  connect(vaporHeater.port,pressurizer. vaporHeater) annotation (Line(points={{-40,
          83},{-38,83},{-38,79.8},{-34,79.8}}, color={191,0,0}));
  connect(liquidHeater.port,pressurizer. liquidHeater) annotation (Line(points={
          {-40,71},{-38,71},{-38,74},{-34,74},{-34,74.2}}, color={191,0,0}));
  connect(Core_OutletPlenum.port_a,Core_OutletPressureDrop. port_b)
    annotation (Line(points={{-60,-26},{-60,-36.65}},
                                                   color={0,127,255}));
  connect(pressurizer.sprayPort,spray. ports[1]) annotation (Line(points={{-31.6,
          84},{-32,84},{-32,89},{-34,89}}, color={0,127,255}));
  connect(pressurizer.reliefPort,relief. ports[1]) annotation (Line(points={{-24.4,
          84},{-24,84},{-24,89},{-22,89}}, color={0,127,255}));
  connect(SG_InletPlenum.port_b,SG_InletPressureDrop. port_a)
    annotation (Line(points={{46,36},{46,28.35}},      color={0,127,255}));
  connect(SG_OutletPressureDrop.port_b,SG_OutletPlenum. port_a)
    annotation (Line(points={{46,-30.35},{46,-44}},
                                                 color={0,0,255}));
  connect(Steam_OutletPipe.port_a,Steam_HelicalCoilOutletPressureDrop. port_b)
    annotation (Line(points={{68,40},{58,40},{58,28.35}},
                                                       color={0,127,255}));
  connect(Steam_InletPipe.port_b,Steam_HelicalCoilInletPressureDrop. port_a)
    annotation (Line(points={{68,-40},{58,-40},{58,-30.35}},
                                                          color={0,127,255}));
  connect(DownComer.port_a,SG_OutletPlenum. port_b) annotation (Line(points={{0,
          -64},{0,-60},{46,-60},{46,-56}}, color={0,127,255}));
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
      points={{-29.9,100.1},{-70,100.1},{-98,100.1},{-98,-72},{-76.4,-72}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Outlet, T_Core_Outlet.T) annotation (Line(
      points={{-29.9,100.1},{-98,100.1},{-98,-44},{-76.4,-44}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(nFlow.port_n, pump.port_a)
    annotation (Line(points={{2,52},{2,52},{8,52}}, color={0,127,255}));
  connect(actuatorBus.speedPump, pump.inputSignal) annotation (Line(
      points={{30.1,100.1},{18,100.1},{18,59}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(PressurizerHeader.port_2, ToHeader_PressureDrop1.port_a)
    annotation (Line(points={{-24,52},{-17.5,52}}, color={0,127,255}));
  connect(ToHeader_PressureDrop1.port_b, nFlow.port_1)
    annotation (Line(points={{-10.5,52},{-4,52}}, color={0,127,255}));
  connect(nFlow1.port_n, pump.port_b)
    annotation (Line(points={{32,52},{30,52},{28,52}}, color={0,127,255}));
  connect(nFlow1.port_1, SG_InletPlenum.port_a)
    annotation (Line(points={{38,52},{46,52},{46,48}}, color={0,127,255}));
  connect(steamGenerator.port_a_shell, SG_InletPressureDrop.port_b) annotation (
     Line(points={{46.94,14},{46,14},{46,20.65}}, color={0,127,255}));
  connect(steamGenerator.port_b_shell, SG_OutletPressureDrop.port_a)
    annotation (Line(points={{46.94,-12},{46.94,-17},{46,-17},{46,-22.65}},
        color={0,127,255}));
  connect(steamGenerator.port_a_tube, Steam_HelicalCoilInletPressureDrop.port_b)
    annotation (Line(points={{52,-12},{60,-12},{60,-22.65},{58,-22.65}}, color={
          0,127,255}));
  connect(steamGenerator.port_b_tube, Steam_HelicalCoilOutletPressureDrop.port_a)
    annotation (Line(points={{52,14},{60,14},{60,20.65},{58,20.65}}, color={0,127,
          255}));

  connect(UpperRiser.port_b, ChargingMixerVolume.port_a[1]) annotation (Line(
        points={{-60,26},{-60,36.4}},            color={0,127,255}));
  connect(ToHeader_PressureDrop.port_a, ChargingMixerVolume.port_b[1])
    annotation (Line(points={{-51.5,52},{-60,52},{-60,43.6}}, color={0,127,255}));
  connect(DownComer.port_b, LowerPlenum.port_a[1])
    annotation (Line(points={{0,-76},{0,-84},{-26.4,-84}}, color={0,127,255}));
  connect(LowerPlenum.port_b[1], Core_InletPressureDrop.port_a) annotation (
      Line(points={{-33.6,-84},{-60,-84},{-60,-78.35}}, color={0,127,255}));
  connect(coreSubchannel.port_b, Core_OutletPressureDrop.port_a) annotation (
      Line(points={{-60,-51},{-60,-44.35}},              color={0,127,255}));
  connect(T_Core_Outlet.port, Core_OutletPressureDrop.port_a) annotation (Line(
        points={{-72,-48},{-60,-48},{-60,-44.35}}, color={0,127,255}));
  connect(T_Core_Inlet.port, coreSubchannel.port_a) annotation (Line(points={{
          -72,-68},{-60,-68},{-60,-65}}, color={0,127,255}));
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
          textString="IRIS: Integral SMR-LWR"),
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
end IRIS;
