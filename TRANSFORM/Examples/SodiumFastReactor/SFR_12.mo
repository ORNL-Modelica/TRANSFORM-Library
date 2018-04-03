within TRANSFORM.Examples.SodiumFastReactor;
model SFR_12

  extends BaseClasses.Partial_SubSystem(
    redeclare replaceable CS_Default CS,
    redeclare replaceable ED_Default ED,
    redeclare Data.SFR_PHS data);

  package Medium_PHTS =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation (Dialog(enable=false));

  package Medium_IHTS =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation (Dialog(enable=false));

  package Medium_DRACS =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation (Dialog(enable=false));

  SI.HeatFlowRate Q_total_shell=sum(IHX.shell.heatTransfer.Q_flows);
  SI.HeatFlowRate Q_total_tube=sum(IHX.tube.heatTransfer.Q_flows);
  SI.Temperature T_up = upperPlenum.medium.T;
  SI.Temperature T_lpo = lowerPlenum_outer.medium.T;
  SI.Temperature T_lp = lowerPlenum.medium.T;

  Nuclear.CoreSubchannels.Regions_2 outerCore(
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
    redeclare package Medium = Medium_PHTS,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            outerCore.coolantSubchannel.heatTransfer.Res,
            outerCore.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-86})));
  Nuclear.CoreSubchannels.Regions_2 innerCore(
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
    redeclare package Medium = Medium_PHTS,
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
  Nuclear.CoreSubchannels.Regions_1 reflector(
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    redeclare package Medium = Medium_PHTS,
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
  Nuclear.CoreSubchannels.Regions_1 shield(
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    redeclare package Medium = Medium_PHTS,
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
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_start,
    T_start=data.T_start_hot,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data.height_upperplenum,
        crossArea=data.crossArea_upperplenum,
        angle=1.5707963267949),
    nPorts_b=7,
    use_HeatPort=true)          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-14})));
  Nuclear.CoreSubchannels.Regions_2 outerCore_out(
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
    redeclare package Medium = Medium_PHTS,
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
            data.PD_ratio)))    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-58})));
  Nuclear.CoreSubchannels.Regions_2 outerCore_in(
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
    redeclare package Medium = Medium_PHTS,
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
  Nuclear.CoreSubchannels.Regions_2 innerCore_out(
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium_PHTS,
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
  Nuclear.CoreSubchannels.Regions_2 innerCore_in(
    redeclare package Material_2 = Media.Solids.SS316,
    p_a_start=data.p_start,
    T_a_start=data.T_start_cold,
    alpha_coolant=0,
    Teffref_fuel=data.T_start_hot,
    Teffref_coolant=data.T_start_hot,
    alpha_fuel=0*data.alpha_outer,
    T_start_1=data.T_start_hot,
    T_start_2=data.T_start_hot,
    redeclare package Medium = Medium_PHTS,
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
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_start,
    h_start=data.h_start_hot,
    A=data.crossArea_expansionVolume,
    V0=0.001,
    level_start=data.level_start_hot_expanstionTank)
    annotation (Placement(transformation(extent={{-64,22},{-44,42}})));
  HeatExchangers.GenericDistributed_HXold IHX[3](
    redeclare package Medium_shell = Medium_PHTS,
    redeclare package Medium_tube = Medium_IHTS,
    redeclare package Material_tubeWall = Media.Solids.SS304,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer,
        S_T=data.pitch_tube,
        S_L=data.pitch_tube),
    T_a_start_shell=data.T_start_hot,
    T_b_start_shell=data.T_start_cold,
    T_a_start_tube=data.T_IHX_inletIHTS,
    T_b_start_tube=data.T_IHX_outletIHTS,
    p_a_start_shell=data.p_start + 0.75e5,
    m_flow_a_start_shell=data.m_flow_PHTS/3,
    m_flow_a_start_tube=data.m_flow_IHX_IHTS,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data.D_shell_outer,
        length_shell=data.length_tube,
        D_i_shell=data.D_downcomerIHX,
        nTubes=data.nTubes,
        nR=3,
        dimension_tube=data.D_tube_inner,
        length_tube=data.length_tube,
        th_wall=data.th_tubewall,
        nV=2,
        angle_shell=-1.5707963267949,
        angle_tube=1.5707963267949),
    p_a_start_tube=350000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-30})));

  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    minY1=min({data.T_IHX_inletIHTS,data.T_IHX_inletPHTS,data.T_IHX_inletIHTS,
        data.T_IHX_oultetPHTS}),
    maxY1=max({data.T_IHX_inletIHTS,data.T_IHX_inletPHTS,data.T_IHX_inletIHTS,
        data.T_IHX_oultetPHTS}),
    x1=IHX[1].tube.summary.xpos_norm,
    y1={IHX[1].tube.mediums[i].T for i in 1:IHX[1].geometry.nV},
    x2=if IHX[1].counterCurrent == true then Modelica.Math.Vectors.reverse(IHX[1].shell.summary.xpos_norm)
         else IHX[1].shell.summary.xpos_norm,
    y2={IHX[1].shell.mediums[i].T for i in 1:IHX[1].geometry.nV})
    annotation (Placement(transformation(extent={{-2,-198},{48,-154}})));
  Fluid.Volumes.MixingVolume lowerPlenum_outer(
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_start,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (crossArea=
           data.crossArea_bottomprimaryVessel, length=data.height_bottomprimaryVessel),
    nPorts_b=3,
    use_HeatPort=true,
    T_start=data.T_start_cold,
    nPorts_a=6) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,-100})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toIHX[3](
      redeclare package Medium = Medium_PHTS, R=50)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Fluid.BoundaryConditions.Boundary_pT boundary_dummy(
    redeclare package Medium = Medium_PHTS,
    T=data.T_start_cold,
    p=data.p_start + 0.75e5,
    nPorts=1) annotation (Placement(transformation(extent={{-6,22},{-14,30}})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank(
      redeclare package Medium = Medium_PHTS, R=1/data.m_flow_PHTS)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,8})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface downcomer[3](
    nParallel=2,
    redeclare package Medium = Medium_PHTS,
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
        origin={-10,-130})));

  Fluid.Machines.Pump pump[3](
    redeclare package Medium = Medium_PHTS,
    m_flow_nominal=data.m_flow_PHTS/3,
    controlType="m_flow",
    T_start=data.T_start_cold,
    dp_nominal=400000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-50})));

  Fluid.Volumes.MixingVolume lowerPlenum(
    nPorts_a=3,
    redeclare package Medium = Medium_PHTS,
    p_start=data.p_start,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=4,
    T_start=data.T_start_cold)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,-160})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistances[4](redeclare
      package Medium = Medium_PHTS, R={2e5/
        data.m_flow_shield,2e5/data.m_flow_reflector,1/data.m_flow_outer,1/data.m_flow_inner})
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-140})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D vessel(
    T_b2_start=0.5*(data.T_start_hot + data.T_ambientGround),
    T_b1_start=data.T_ambientGround,
    exposeState_b1=true,
    exposeState_a2=false,
    redeclare package Material = Media.Solids.SS304,
    T_a1_start=0.5*(data.T_start_cold + data.T_start_cold),
    T_a2_start=0.5*(data.T_start_cold + data.T_ambientGround),
    redeclare model Geometry =
        HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        r_inner=0.5*data.D_inner_primaryVessel,
        length_z=data.length_Vessel,
        nR=6,
        r_outer=0.5*data.D_outer_guardVessel,
        nZ=2)) "primary and guard vessel"
    annotation (Placement(transformation(extent={{72,-150},{92,-130}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(nPorts=
       2, T=fill(data.T_ambientGround, boundary.nPorts))
    annotation (Placement(transformation(extent={{120,-150},{100,-130}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection[2](
      surfaceArea={vessel.geometry.crossAreas_1[1, 1],vessel.geometry.crossAreas_1
        [1, 2]}, alpha={1000,100})
    annotation (Placement(transformation(extent={{42,-150},{62,-130}})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toExpTank1(
      redeclare package Medium = Medium_PHTS, R=1e6)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,26})));

  Components.IHTS5_AHX2
                   IHTS[3](
    redeclare package Medium = Medium_IHTS)
    annotation (Placement(transformation(extent={{60,-52},{120,8}})));

  HeatExchangers.GenericDistributed_HXold IHX1[3](
    redeclare package Medium_shell = Medium_PHTS,
    redeclare package Material_tubeWall = Media.Solids.SS304,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer,
        S_T=data.pitch_tube,
        S_L=data.pitch_tube),
    T_a_start_shell=data.T_start_hot,
    T_b_start_shell=data.T_start_cold,
    T_a_start_tube=data.T_IHX_inletIHTS,
    T_b_start_tube=data.T_IHX_outletIHTS,
    p_a_start_shell=data.p_start + 0.75e5,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        nV=2,
        D_o_shell=data.D_shell_outerDRACS,
        nTubes=data.nTubes_DRACS,
        length_shell=data.length_tubeDRACS,
        angle_shell=-1.5707963267949,
        dimension_tube=data.D_tube_innerDRACS,
        length_tube=data.length_tubeDRACS,
        angle_tube=1.5707963267949,
        th_wall=data.th_tubewallDRACS),
    redeclare package Medium_tube = Medium_DRACS,
    m_flow_a_start_shell=data.m_flow_DRACS,
    p_a_start_tube=350000,
    m_flow_a_start_tube=data.m_flow_DRACSsec) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-124,-30})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toDRACS[3](
      redeclare package Medium = Medium_PHTS, R=50)
    annotation (Placement(transformation(extent={{-110,-16},{-90,4}})));
  Components.DRACS_ADHX dRACS_ADHX[3](redeclare package Medium =
        Medium_DRACS)
    annotation (Placement(transformation(extent={{-156,-52},{-216,8}})));
equation

  connect(upperPlenum.heatPort, convection[2].port_a) annotation (Line(points={{
          -54,-14},{13,-14},{13,-140},{45,-140}}, color={191,0,0}));
  connect(shield.port_b, upperPlenum.port_a[1]) annotation (Line(points={{-100,-76},
          {-100,-20},{-59.25,-20}},          color={0,127,255}));
  connect(reflector.port_b, upperPlenum.port_a[2]) annotation (Line(points={{-80,-76},
          {-80,-20},{-59.75,-20}},      color={0,127,255}));
  connect(outerCore.port_b, outerCore_out.port_a)
    annotation (Line(points={{-60,-76},{-60,-68}},
                                                color={0,127,255}));
  connect(outerCore_out.port_b, upperPlenum.port_a[3]) annotation (Line(points={{-60,-48},
          {-60,-20},{-60.25,-20}},         color={0,127,255}));
  connect(outerCore_in.port_b, outerCore.port_a) annotation (Line(points={{-60,-104},
          {-60,-96}},                color={0,127,255}));
  connect(innerCore.port_b, innerCore_out.port_a)
    annotation (Line(points={{-38,-76},{-38,-68}},
                                              color={0,127,255}));
  connect(innerCore_out.port_b, upperPlenum.port_a[4])
    annotation (Line(points={{-38,-48},{-38,-20},{-60.75,-20}},
                                                           color={0,127,255}));
  connect(innerCore_in.port_b, innerCore.port_a)
    annotation (Line(points={{-38,-104},{-38,-96}},
                                                 color={0,127,255}));
  connect(resistance_toExpTank.port_a, upperPlenum.port_b[1]) annotation (Line(
        points={{-60,1},{-60,-8},{-59.1429,-8}},
                                               color={0,127,255}));
  connect(downcomer.port_a, pump.port_b)
    annotation (Line(points={{-10,-120},{-10,-60}}, color={0,127,255}));
  connect(lowerPlenum.port_a[1:3], downcomer.port_b) annotation (Line(points={{
          -59.3333,-166},{-10,-166},{-10,-140}},
                                        color={0,127,255}));
  connect(resistances[1].port_b, shield.port_a) annotation (Line(points={{-60,-133},
          {-100,-133},{-100,-96}}, color={0,127,255}));
  connect(reflector.port_a, resistances[2].port_b) annotation (Line(points={{-80,
          -96},{-80,-133},{-60,-133}}, color={0,127,255}));
  connect(resistances[3].port_b, outerCore_in.port_a)
    annotation (Line(points={{-60,-133},{-60,-124}}, color={0,127,255}));
  connect(resistances[4].port_b, innerCore_in.port_a) annotation (Line(points={{
          -60,-133},{-38,-133},{-38,-124}}, color={0,127,255}));
  connect(lowerPlenum.port_b[1:4], resistances.port_a) annotation (Line(points={
          {-59.25,-154},{-60,-154},{-60,-147}}, color={0,127,255}));
  connect(resistance_toExpTank.port_b, expansionTank.port_a)
    annotation (Line(points={{-60,15},{-60,26}}, color={0,127,255}));
  connect(lowerPlenum_outer.port_b[1:3], pump.port_a) annotation (Line(points={{4,
          -99.3333},{0,-99.3333},{0,-32},{-10,-32},{-10,-40}},   color={0,127,255}));
  connect(convection.port_b, vessel.port_a1)
    annotation (Line(points={{59,-140},{72,-140}}, color={191,0,0}));
  connect(vessel.port_b1, boundary.port)
    annotation (Line(points={{92,-140},{100,-140}}, color={191,0,0}));
  connect(lowerPlenum_outer.heatPort, convection[1].port_a)
    annotation (Line(points={{10,-106},{10,-140},{45,-140}}, color={191,0,0}));
  connect(resistance_toIHX.port_a, upperPlenum.port_b[2:4]) annotation (Line(
        points={{-33,-6},{-60,-6},{-60,-8}},       color={0,127,255}));
  connect(resistance_toIHX.port_b, IHX.port_a_shell) annotation (Line(points={{-19,-6},
          {27.4,-6},{27.4,-20}},     color={0,127,255}));
  connect(IHX.port_b_shell, lowerPlenum_outer.port_a[1:3]) annotation (Line(
        points={{27.4,-40},{28,-40},{28,-50},{28,-50},{28,-100.167},{16,
          -100.167}},                                             color={0,127,255}));
  connect(expansionTank.port_b, resistance_toExpTank1.port_a)
    annotation (Line(points={{-48,26},{-37,26}}, color={0,127,255}));
  connect(resistance_toExpTank1.port_b, boundary_dummy.ports[1])
    annotation (Line(points={{-23,26},{-14,26}}, color={0,127,255}));
  connect(IHTS.port_b, IHX.port_b_tube)
    annotation (Line(points={{60,-10},{32,-10},{32,-20}}, color={0,127,255}));
  connect(IHTS.port_a, IHX.port_a_tube) annotation (Line(points={{60,-40},{50,-40},
          {50,-52},{40,-52},{40,-52},{32,-52},{32,-40}},
                                       color={0,127,255}));
  connect(resistance_toDRACS.port_b, upperPlenum.port_b[5:7]) annotation (Line(
        points={{-93,-6},{-60.8571,-6},{-60.8571,-8}}, color={0,127,255}));
  connect(resistance_toDRACS.port_a, IHX1.port_a_shell) annotation (Line(points=
         {{-107,-6},{-119.4,-6},{-119.4,-20}}, color={0,127,255}));
  connect(IHX1.port_b_shell, lowerPlenum_outer.port_a[4:6]) annotation (Line(
        points={{-119.4,-40},{-120,-40},{-120,-50},{-110,-50},{-110,-28},{20,
          -28},{20,-99.1667},{16,-99.1667}},
                                        color={0,127,255}));
  connect(dRACS_ADHX.port_b, IHX1.port_b_tube) annotation (Line(points={{-156,
          -10},{-124,-10},{-124,-20}}, color={0,127,255}));
  connect(IHX1.port_a_tube, dRACS_ADHX.port_a) annotation (Line(points={{-124,
          -40},{-124,-50},{-140,-50},{-140,-40},{-156,-40}}, color={0,127,255}));
  annotation (
    defaultComponentName="PHS",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{160,
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
          rotation=-90)}),
    experiment(StopTime=8640, __Dymola_NumberOfIntervals=864));
end SFR_12;
