within TRANSFORM.Examples.SodiumFastReactor;
model SFR_1

  extends BaseClasses.Partial_SubSystem(
    redeclare replaceable CS_Default CS,
    redeclare replaceable ED_Default ED,
    redeclare Data.SFR_PHS data);

  package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation (Dialog(enable=false));

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
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus (Nus0=
           HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
            outerCore.coolantSubchannel.heatTransfer.Res,
            outerCore.coolantSubchannel.heatTransfer.Prs,
            data.PD_ratio))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-6})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary2(         redeclare
      package Medium = Medium,
    T=data.T_start_cold,
    m_flow=data.m_flow_inner,
    nPorts=1)
    annotation (Placement(transformation(extent={{72,-96},{52,-76}})));
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
        origin={12,-6})));
  Nuclear.CoreSubchannels.Regions_1 reflector(
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
        origin={-30,-6})));
  Nuclear.CoreSubchannels.Regions_1 shield(
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
        origin={-50,-6})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary4(         redeclare
      package Medium = Medium,
    T=data.T_start_cold,
    nPorts=1,
    m_flow=data.m_flow_shield)
    annotation (Placement(transformation(extent={{-100,-106},{-80,-86}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary5(         redeclare
      package Medium = Medium,
    T=data.T_start_cold,
    nPorts=1,
    m_flow=data.m_flow_reflector)
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary8(         redeclare
      package Medium = Medium,
    T=data.T_start_cold,
    m_flow=data.m_flow_outer,
    nPorts=1)
    annotation (Placement(transformation(extent={{18,-98},{-2,-78}})));
  Fluid.Volumes.MixingVolume upperPlenum(
    nPorts_a=4,
    nPorts_b=3,
    redeclare package Medium = Medium,
    p_start=data.p_start,
    T_start=data.T_start_hot,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data.height_upperplenum,
        crossArea=data.crossArea_upperplenum,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,50})));
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
            data.PD_ratio)))    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,22})));
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
        origin={-10,-34})));
  Nuclear.CoreSubchannels.Regions_2 innerCore_out(
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
        origin={12,22})));
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
        origin={12,-34})));
  Fluid.Volumes.ExpansionTank_1Port
                              expansionTank(
    redeclare package Medium = Medium,
    p_start=data.p_start,
    h_start=data.h_start_hot,
    A=data.crossArea_expansionVolume,
    V0=0.001,
    level_start=data.level_start_hot_expanstionTank)
    annotation (Placement(transformation(extent={{-68,70},{-48,90}})));
  Fluid.BoundaryConditions.Boundary_pT boundary3(          redeclare package
              Medium =
               Medium,
    nPorts=1,
    T=data.T_start_cold,
    p=data.p_start + 3e4)
    annotation (Placement(transformation(extent={{78,-28},{98,-8}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary7(         redeclare
      package Medium = Medium,
    nPorts=1,
    T=data.T_IHX_inletIHTS,
    m_flow=data.nIHXs*data.m_flow_IHX_IHTS)
    annotation (Placement(transformation(extent={{170,-32},{150,-12}})));
  Fluid.BoundaryConditions.Boundary_pT boundary9(          redeclare package
              Medium =
               Medium,
    nPorts=1,
    p=data.p_start,
    T=data.T_IHX_outletIHTS)
    annotation (Placement(transformation(extent={{168,48},{148,68}})));
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
        origin={120,6})));

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
    annotation (Placement(transformation(extent={{102,-88},{152,-44}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
              Medium =
               Media.Fluids.Sodium.ConstantPropertyLiquidSodium, R=50)
    annotation (Placement(transformation(extent={{58,34},{78,54}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance1(redeclare
      package Medium = Media.Fluids.Sodium.ConstantPropertyLiquidSodium, R=1/
        data.m_flow_PHTS) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-29,71})));
  Fluid.BoundaryConditions.Boundary_pT boundary6(          redeclare package
              Medium =
               Medium,
    nPorts=1,
    T=data.T_start_cold,
    p=data.p_start + 0.75e5)
    annotation (Placement(transformation(extent={{68,70},{48,90}})));
equation

  connect(boundary4.ports[1], shield.port_a) annotation (Line(points={{-80,-96},
          {-50,-96},{-50,-16}},                     color={0,127,255}));
  connect(boundary5.ports[1], reflector.port_a) annotation (Line(points={{-40,-90},
          {-40,-54},{-30,-54},{-30,-18},{-30,-18},{-30,-16},{-30,-16}},
                                               color={0,127,255}));
  connect(shield.port_b, upperPlenum.port_a[1]) annotation (Line(points={{-50,4},
          {-70,4},{-70,44},{-9.25,44}},      color={0,127,255}));
  connect(reflector.port_b, upperPlenum.port_a[2]) annotation (Line(points={{-30,4},
          {-30,44},{-9.75,44}},         color={0,127,255}));
  connect(outerCore.port_b, outerCore_out.port_a)
    annotation (Line(points={{-10,4},{-10,12}}, color={0,127,255}));
  connect(outerCore_out.port_b, upperPlenum.port_a[3]) annotation (Line(points=
          {{-10,32},{-10,44},{-10.25,44}}, color={0,127,255}));
  connect(boundary8.ports[1], outerCore_in.port_a) annotation (Line(points={{-2,
          -88},{-10,-88},{-10,-44}}, color={0,127,255}));
  connect(outerCore_in.port_b, outerCore.port_a) annotation (Line(points={{-10,
          -24},{-10,-20},{-10,-16}}, color={0,127,255}));
  connect(innerCore.port_b, innerCore_out.port_a)
    annotation (Line(points={{12,4},{12,12}}, color={0,127,255}));
  connect(innerCore_out.port_b, upperPlenum.port_a[4])
    annotation (Line(points={{12,32},{12,44},{-10.75,44}}, color={0,127,255}));
  connect(boundary2.ports[1], innerCore_in.port_a)
    annotation (Line(points={{52,-86},{12,-86},{12,-44}}, color={0,127,255}));
  connect(innerCore_in.port_b, innerCore.port_a)
    annotation (Line(points={{12,-24},{12,-16}}, color={0,127,255}));
  connect(boundary3.ports[1], STHX.port_b_shell) annotation (Line(points={{98,
          -18},{104,-18},{104,-16},{115.4,-16},{115.4,-4}}, color={0,127,255}));
  connect(boundary7.ports[1], STHX.port_a_tube) annotation (Line(points={{150,
          -22},{138,-22},{138,-20},{120,-20},{120,-4}}, color={0,127,255}));
  connect(boundary9.ports[1], STHX.port_b_tube) annotation (Line(points={{148,
          58},{136,58},{120,58},{120,16}}, color={0,127,255}));
  connect(resistance.port_a, upperPlenum.port_b[1]) annotation (Line(points={{
          61,44},{30,44},{30,66},{-9.33333,66},{-9.33333,56}}, color={0,127,255}));
  connect(resistance.port_b, STHX.port_a_shell) annotation (Line(points={{75,44},
          {115.4,44},{115.4,16}}, color={0,127,255}));
  connect(upperPlenum.port_b[2], resistance1.port_a) annotation (Line(points={{
          -10,56},{-10,71},{-24.1,71}}, color={0,127,255}));
  connect(resistance1.port_b, expansionTank.port) annotation (Line(points={{
          -33.9,71},{-45.95,71},{-45.95,71.6},{-58,71.6}}, color={0,127,255}));
  connect(boundary6.ports[1], upperPlenum.port_b[3]) annotation (Line(points={{48,80},
          {-10.6667,80},{-10.6667,56}},        color={0,127,255}));
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
          rotation=-90)}),
    experiment(StopTime=1000));
end SFR_1;
