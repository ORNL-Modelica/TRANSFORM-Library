within TRANSFORM.Examples.SodiumFastReactor;
model SFR_3

  extends BaseClasses.Partial_SubSystem(
    redeclare replaceable CS_Default CS,
    redeclare replaceable ED_Default ED,
    redeclare Data.SFR_PHS data);

  package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation (Dialog(enable=false));

  Nuclear.CoreSubchannels.Regions_2old outerCore(
    nParallel=data.nOuterCore,
    redeclare package Material_1 = Media.Solids.UO2,
    redeclare package Material_2 = Media.Solids.SS316,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        length=data.length_subassembly_active,
        angle=1.5707963267949,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal"),
    Q_nominal=data.Q_outer_nominal,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    T_b_start=data.T_start_hot,
    m_flow_a_start=data.m_flow_outer,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            outerCore.coolantSubchannel.heatTransfer.Res,
            outerCore.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-86})));
  Nuclear.CoreSubchannels.Regions_2old innerCore(
    redeclare package Material_1 = Media.Solids.UO2,
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    T_b_start=data.T_start_hot,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            innerCore.coolantSubchannel.heatTransfer.Res,
            innerCore.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        length=data.length_subassembly_active,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal",
        angle=1.5707963267949),
    nParallel=data.nInnerCore,
    Q_nominal=data.Q_inner_nominal,
    m_flow_a_start=data.m_flow_inner) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-38,-86})));
  Nuclear.CoreSubchannels.Regions_1old reflector(
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    redeclare package Medium = Medium,
    redeclare package Material_1 = Media.Solids.SS316,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            reflector.coolantSubchannel.heatTransfer.Res,
            reflector.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    Q_nominal=0,
    nParallel=data.nReflector,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        assemblyType="Hexagonal",
        rs_outer={0.5*data.D_pin},
        length=data.length_total,
        angle=1.5707963267949),
    m_flow_a_start=data.m_flow_reflector,
    T_start_1=data.T_start_cold) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-86})));
  Nuclear.CoreSubchannels.Regions_1old shield(
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    redeclare package Medium = Medium,
    redeclare package Material_1 = Media.Solids.SS316,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            shield.coolantSubchannel.heatTransfer.Res,
            shield.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    Q_nominal=0,
    nParallel=data.nShield,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        assemblyType="Hexagonal",
        rs_outer={0.5*data.D_pin},
        length=data.length_total,
        angle=1.5707963267949),
    m_flow_a_start=data.m_flow_shield,
    T_start_1=data.T_start_cold) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,-86})));
  Fluid.Volumes.MixingVolume upperPlenum(
    nPorts_a=4,
    redeclare package Medium = Medium,
    p_start=data.p_start,
    T_start=data.T_start_hot,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data.height_upperplenum,
        crossArea=data.crossArea_upperplenum,
        angle=1.5707963267949),
    nPorts_b=2)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-34})));
  Nuclear.CoreSubchannels.Regions_2old outerCore_out(
    nParallel=data.nOuterCore,
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    m_flow_a_start=data.m_flow_outer,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare package Material_1 = Media.Solids.Helium,
    Q_nominal=0,
    T_a_start=data.T_start_hot,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal",
        length=data.length_out,
        nV=2,
        angle=1.5707963267949),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            outerCore_out.coolantSubchannel.heatTransfer.Res,
            outerCore_out.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-58})));
  Nuclear.CoreSubchannels.Regions_2old outerCore_in(
    nParallel=data.nOuterCore,
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    m_flow_a_start=data.m_flow_outer,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            outerCore_in.coolantSubchannel.heatTransfer.Res,
            outerCore_in.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    Q_nominal=0,
    redeclare package Material_1 = Media.Solids.SS316,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal",
        length=data.length_in,
        nV=2,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-114})));
  Nuclear.CoreSubchannels.Regions_2old innerCore_out(
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            innerCore_out.coolantSubchannel.heatTransfer.Res,
            innerCore_out.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    nParallel=data.nInnerCore,
    m_flow_a_start=data.m_flow_inner,
    redeclare package Material_1 = Media.Solids.Helium,
    Q_nominal=0,
    T_a_start=data.T_start_hot,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal",
        length=data.length_out,
        nV=2,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-38,-58})));
  Nuclear.CoreSubchannels.Regions_2old innerCore_in(
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            innerCore_in.coolantSubchannel.heatTransfer.Res,
            innerCore_in.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio)),
    nParallel=data.nInnerCore,
    m_flow_a_start=data.m_flow_inner,
    Q_nominal=0,
    redeclare package Material_1 = Media.Solids.SS316,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly (
        nPins=data.nPins_perSub,
        width_FtoF_inner=data.width_duct_inside,
        D_wireWrap=data.D_wireWrap,
        rs_outer={0.5*data.D_pin - data.th_clad,0.5*data.D_pin},
        assemblyType="Hexagonal",
        length=data.length_in,
        nV=2,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-38,-114})));
  Fluid.Volumes.ExpansionTank expansionTank(
    redeclare package Medium = Medium,
    p_start=data.p_start,
    h_start=data.h_start_hot,
    A=data.crossArea_expansionVolume,
    V0=0.001,
    level_start=data.level_start_hot_expanstionTank)
    annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary7(         redeclare
      package Medium = Medium,
    nPorts=1,
    T=data.T_IHX_inletIHTS,
    m_flow=data.nIHXs*data.m_flow_IHX_IHTS)
    annotation (Placement(transformation(extent={{120,-112},{100,-92}})));
  Fluid.BoundaryConditions.Boundary_pT boundary9(          redeclare package
      Medium = Medium,
    nPorts=1,
    p=data.p_start,
    T=data.T_IHX_outletIHTS)
    annotation (Placement(transformation(extent={{118,-32},{98,-12}})));
  HeatExchangers.GenericDistributed_HXold STHX(
    nParallel=data.nIHXs,
    redeclare package Medium_shell = Medium,
    redeclare package Medium_tube = Medium,
    redeclare package Material_tubeWall = Media.Solids.SS304,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer,
        S_T=data.pitch_tube,
        S_L=data.pitch_tube),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data.D_shell_outer,
        nV=10,
        length_shell=data.length_tube,
        D_i_shell=data.D_downcomerIHX,
        nTubes=data.nTubes,
        nR=3,
        angle_shell=-1.5707963267949,
        dimension_tube=data.D_tube_inner,
        length_tube=data.length_tube,
        angle_tube=1.5707963267949,
        th_wall=data.th_tubewall),
    T_a_start_shell=data.T_start_hot,
    T_b_start_shell=data.T_start_cold,
    m_flow_a_start_shell=data.m_flow_PHTS,
    p_a_start_tube=data.p_start,
    m_flow_a_start_tube=data.nIHXs*data.m_flow_IHX_IHTS,
    T_a_start_tube=data.T_IHX_inletIHTS,
    T_b_start_tube=data.T_IHX_outletIHTS,
    p_a_start_shell=data.p_start + 0.75e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-74})));

  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    x1=STHX.tube.summary.xpos_norm,
    x2=if STHX.counterCurrent == true then Modelica.Math.Vectors.reverse(STHX.shell.summary.xpos_norm)
         else STHX.shell.summary.xpos_norm,
    y2={STHX.shell.mediums[i].T for i in 1:STHX.geometry.nV},
    y1={STHX.tube.mediums[i].T for i in 1:STHX.geometry.nV},
    minY1=min({data.T_IHX_inletIHTS,data.T_IHX_inletPHTS,data.T_IHX_inletIHTS,
        data.T_IHX_oultetPHTS}),
    maxY1=max({data.T_IHX_inletIHTS,data.T_IHX_inletPHTS,data.T_IHX_inletIHTS,
        data.T_IHX_oultetPHTS}))
    annotation (Placement(transformation(extent={{84,-174},{134,-130}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toIHX1(redeclare
      package Medium = Media.Fluids.Sodium.ConstantPropertyLiquidSodium, R=50)
    annotation (Placement(transformation(extent={{-10,-36},{10,-16}})));
  Fluid.BoundaryConditions.Boundary_pT boundary_dummy(
    redeclare package Medium = Medium,
    T=data.T_start_cold,
    p=data.p_start + 0.75e5,
    nPorts=1) annotation (Placement(transformation(extent={{-32,2},{-40,10}})));
  Fluid.Volumes.MixingVolume upperPlenum1(
    nPorts_a=1,
    redeclare package Medium = Medium,
    p_start=data.p_start,
    T_start=data.T_start_hot,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=3)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-100})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank(
      redeclare package Medium =
        Media.Fluids.Sodium.ConstantPropertyLiquidSodium, R=1/data.m_flow_PHTS)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-12})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface downcomer[3](
    nParallel=2,
    redeclare package Medium =
        Media.Fluids.Sodium.ConstantPropertyLiquidSodium,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    m_flow_b_start=data.m_flow_PHTS/3,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=data.D_downcomerIHX,
        length=data.length_pumpDowncomer,
        angle=-1.5707963267949)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={8,-126})));

  Fluid.Machines.Pump_SimpleMassFlow pump[3](redeclare package Medium =
        Media.Fluids.Sodium.ConstantPropertyLiquidSodium, m_flow_nominal=data.m_flow_PHTS
        /3) annotation (Placement(transformation(extent={{38,-110},{18,-90}})));
  Fluid.Volumes.MixingVolume upperPlenum2(
    nPorts_a=3,
    redeclare package Medium = Medium,
    p_start=data.p_start,
    T_start=data.T_start_hot,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=4)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-20,-150})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistances[4](redeclare
      package Medium = Media.Fluids.Sodium.ConstantPropertyLiquidSodium, R={2e5
        /data.m_flow_shield,2e5/data.m_flow_reflector,1/data.m_flow_outer,1/
        data.m_flow_inner}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-140})));
equation

  connect(shield.port_b, upperPlenum.port_a[1]) annotation (Line(points={{-100,
          -76},{-100,-40},{-59.25,-40}},     color={0,127,255}));
  connect(reflector.port_b, upperPlenum.port_a[2]) annotation (Line(points={{-80,-76},
          {-80,-40},{-59.75,-40}},      color={0,127,255}));
  connect(outerCore.port_b, outerCore_out.port_a)
    annotation (Line(points={{-60,-76},{-60,-68}},
                                                color={0,127,255}));
  connect(outerCore_out.port_b, upperPlenum.port_a[3]) annotation (Line(points={{-60,-48},
          {-60,-40},{-60.25,-40}},         color={0,127,255}));
  connect(outerCore_in.port_b, outerCore.port_a) annotation (Line(points={{-60,
          -104},{-60,-96}},          color={0,127,255}));
  connect(innerCore.port_b, innerCore_out.port_a)
    annotation (Line(points={{-38,-76},{-38,-68}},
                                              color={0,127,255}));
  connect(innerCore_out.port_b, upperPlenum.port_a[4])
    annotation (Line(points={{-38,-48},{-38,-40},{-60.75,-40}},
                                                           color={0,127,255}));
  connect(innerCore_in.port_b, innerCore.port_a)
    annotation (Line(points={{-38,-104},{-38,-96}},
                                                 color={0,127,255}));
  connect(boundary7.ports[1], STHX.port_a_tube) annotation (Line(points={{100,
          -102},{88,-102},{88,-100},{70,-100},{70,-84}},color={0,127,255}));
  connect(boundary9.ports[1], STHX.port_b_tube) annotation (Line(points={{98,-22},
          {70,-22},{70,-64}},              color={0,127,255}));
  connect(resistance_toIHX1.port_b, STHX.port_a_shell) annotation (Line(points=
          {{7,-26},{65.4,-26},{65.4,-64}}, color={0,127,255}));
  connect(upperPlenum1.port_a[1], STHX.port_b_shell) annotation (Line(points={{
          56,-100},{65.4,-100},{65.4,-84}}, color={0,127,255}));
  connect(resistance_toExpTank.port_a, upperPlenum.port_b[1]) annotation (Line(
        points={{-60,-19},{-60,-24},{-60,-28},{-59.5,-28}}, color={0,127,255}));
  connect(resistance_toIHX1.port_a, upperPlenum.port_b[2]) annotation (Line(
        points={{-7,-26},{-60.5,-26},{-60.5,-28}}, color={0,127,255}));
  connect(resistance_toExpTank.port_b, expansionTank.port_a)
    annotation (Line(points={{-60,-5},{-60,6}}, color={0,127,255}));
  connect(boundary_dummy.ports[1], expansionTank.port_b)
    annotation (Line(points={{-40,6},{-48,6}}, color={0,127,255}));
  connect(downcomer.port_a, pump.port_b)
    annotation (Line(points={{8,-116},{8,-100},{18,-100}}, color={0,127,255}));
  connect(pump.port_a, upperPlenum1.port_b[1:3]) annotation (Line(points={{38,-100},
          {42,-100},{42,-100.667},{44,-100.667}},       color={0,127,255}));
  connect(upperPlenum2.port_a[1:3], downcomer.port_b) annotation (Line(points={{-14,
          -150.667},{8,-150.667},{8,-136}},      color={0,127,255}));
  connect(resistances[1].port_b, shield.port_a) annotation (Line(points={{-60,
          -133},{-100,-133},{-100,-96}}, color={0,127,255}));
  connect(reflector.port_a, resistances[2].port_b) annotation (Line(points={{
          -80,-96},{-80,-133},{-60,-133}}, color={0,127,255}));
  connect(resistances[3].port_b, outerCore_in.port_a)
    annotation (Line(points={{-60,-133},{-60,-124}}, color={0,127,255}));
  connect(resistances[4].port_b, innerCore_in.port_a) annotation (Line(points={
          {-60,-133},{-38,-133},{-38,-124}}, color={0,127,255}));
  connect(upperPlenum2.port_b[1:4], resistances.port_a) annotation (Line(points=
         {{-26,-150.75},{-60,-150.75},{-60,-147}}, color={0,127,255}));
  annotation (
    defaultComponentName="PHS",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{
            200,140}})),
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
          rotation=-90)}),
    experiment(StopTime=1000));
end SFR_3;
