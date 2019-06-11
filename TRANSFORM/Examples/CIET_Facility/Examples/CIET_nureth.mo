within TRANSFORM.Examples.CIET_Facility.Examples;
model CIET_nureth "Final model of the CIET facility"

  // CIET2_NURETH_CALIBRATED_20190227_FINAL
  extends TRANSFORM.Icons.Example;

  Real M43=S1.pipe.port_a.p;
  Real RTD40=S1.pipe.mediums[5].T;
  Real M40=S2.port_b.p;
  Real BT30=S4.pipe.mediums[2].T;
  Real WT31=S4.pipe.flowModel.Ts_fluid[2];
  Real BT11=S5.pipe.mediums[2].T;
  Real WT10=S5.pipe.flowModel.Ts_fluid[2];
  Real M10=S5.port_a.p;
  Real M11=S7.port_b.p;
  Real CX10=S7.pipe.mediums[2].T;
  Real M12=S8.pipe.mediums[2].p;
  Real CX11=S8.pipe.mediums[3].T;
  Real BT12=S8.pipe.mediums[3].T;
  Real WT13=S8.pipe.flowModel.Ts_fluid[3];
  Real BT43=S10.pipe.mediums[4].T;
  Real WT42=S10.pipe.flowModel.Ts_fluid[4];
  Real M45=S10.pipe.mediums[4].p;
  Real M44=S12.port_a.p;
  Real BT41=S12.pipe.mediums[3].T;
  Real WT40=S12.pipe.flowModel.Ts_fluid[3];
  Real M41=S15.pipe.mediums[3].p;
  Real M42=S15.pipe.mediums[4].p;
  Real CTAH_Frequency=FanFrequency.y;
  Real Power_Input_Signal=PowerTable.y;
  Real Pump_Frequency=FanFrequency.y;
  Real FM40=S2.port_a.m_flow;

  package Medium = TRANSFORM.Media.Fluids.DOWTHERM.LinearDOWTHERM_A_95C;
  package Material_wall = TRANSFORM.Media.Solids.SS304_TRACE;
  package Material_insulation = TRANSFORM.Media.Solids.FiberGlassGeneric;

  // Modelica.SIunits.Power Q_heater_fluid=-sum(wall_6.port_a.Q_flow);
  // Modelica.SIunits.Power Q_heater_ambient=-sum(wall_6.port_b.Q_flow);

  Modelica.SIunits.Power Q_insulation=sum(S7.boundary.port.Q_flow) + sum(S8.boundary.port.Q_flow)
       + sum(S9.boundary.port.Q_flow) + sum(S10.boundary.port.Q_flow) + sum(S12.boundary.port.Q_flow)
       + sum(S13.boundary.port.Q_flow) + sum(S14.boundary.port.Q_flow) + sum(
      S15.boundary.port.Q_flow) + sum(S1.boundary.port.Q_flow) + sum(S2.boundary.port.Q_flow)
       + sum(S3.boundary.port.Q_flow) + sum(S4.boundary.port.Q_flow) + sum(S5.boundary.port.Q_flow);

  Modelica.SIunits.Power Q_H2C=sum(S7.boundary.port.Q_flow) + sum(S8.boundary.port.Q_flow)
       + sum(S9.boundary.port.Q_flow) + sum(S10.boundary.port.Q_flow);

  Modelica.SIunits.Power Q_C2H=sum(S12.boundary.port.Q_flow) + sum(S13.boundary.port.Q_flow)
       + sum(S14.boundary.port.Q_flow) + sum(S15.boundary.port.Q_flow) + sum(S1.boundary.port.Q_flow)
       + sum(S2.boundary.port.Q_flow) + sum(S3.boundary.port.Q_flow) + sum(S4.boundary.port.Q_flow)
       + sum(S5.boundary.port.Q_flow);

  Modelica.SIunits.Power Q_ctah=sum(S11.heatPorts.Q_flow);

  TRANSFORM.HeatAndMassTransfer.Volumes.SimpleWall thermalMass[integer(data.pipes.table[
    data.index_1, 1])](
    th=0.3,
    surfaceArea=0.004,
    T_start=294.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,8})));
  TRANSFORM.HeatAndMassTransfer.Volumes.SimpleWall thermalMass1[integer(data.pipes.table[
    data.index_1, 1])](
    th=5,
    surfaceArea=0.09,
    T_start=294.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,38})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S7(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_wall=fill(data.pipes.table[data.index_7, 11], integer(data.pipes.table[
        data.index_7, 1])),
    ths_insulation=fill(data.pipes.table[data.index_7, 12], integer(data.pipes.table[
        data.index_7, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_7,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_7, 4],
        crossArea=data.pipes.table[data.index_7, 5],
        length=data.pipes.table[data.index_7, 2],
        angle=data.pipes.table[data.index_7, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_7, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_7, 7],
    p_b_start=data.pipes.table[data.index_7, 8],
    T_a_start=data.pipes.table[data.index_7, 9],
    T_b_start=data.pipes.table[data.index_7, 10],
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_9, 1])))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=200,
        origin={-88,22})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S8(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_wall=fill(data.pipes.table[data.index_8, 11], integer(data.pipes.table[
        data.index_8, 1])),
    ths_insulation=fill(data.pipes.table[data.index_8, 12], integer(data.pipes.table[
        data.index_8, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_8,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_8, 4],
        crossArea=data.pipes.table[data.index_8, 5],
        length=data.pipes.table[data.index_8, 2],
        angle=data.pipes.table[data.index_8, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_8, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_8, 7],
    p_b_start=data.pipes.table[data.index_8, 8],
    T_a_start=data.pipes.table[data.index_8, 9],
    T_b_start=data.pipes.table[data.index_8, 10],
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_8, 1])))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=240,
        origin={-76,114})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S9(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_wall=fill(data.pipes.table[data.index_9, 11], integer(data.pipes.table[
        data.index_9, 1])),
    ths_insulation=fill(data.pipes.table[data.index_9, 12], integer(data.pipes.table[
        data.index_9, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_9,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_9, 4],
        crossArea=data.pipes.table[data.index_9, 5],
        length=data.pipes.table[data.index_9, 2],
        angle=data.pipes.table[data.index_9, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_9, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_9, 7],
    p_b_start=data.pipes.table[data.index_9, 8],
    T_a_start=data.pipes.table[data.index_9, 9],
    T_b_start=data.pipes.table[data.index_9, 10],
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_9, 1])))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,138})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S10(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_wall=fill(data.pipes.table[data.index_10, 11], integer(data.pipes.table[
        data.index_10, 1])),
    ths_insulation=fill(data.pipes.table[data.index_10, 12], integer(data.pipes.table[
        data.index_10, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_10,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_10, 4],
        crossArea=data.pipes.table[data.index_10, 5],
        length=data.pipes.table[data.index_10, 2],
        angle=data.pipes.table[data.index_10, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_10, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_10, 7],
    p_b_start=data.pipes.table[data.index_10, 8],
    T_a_start=data.pipes.table[data.index_10, 9],
    T_b_start=data.pipes.table[data.index_10, 10],
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_10, 1])))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={48,158})));

  Fluid.Pipes.GenericPipe_withWall S11(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    use_HeatTransferOuter=true,
    exposeState_outerWall=true,
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_11, 7],
    p_b_start=data.pipes.table[data.index_11, 8],
    T_a_start=data.pipes.table[data.index_11, 9],
    T_b_start=data.pipes.table[data.index_11, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal,
    redeclare package Material = TRANSFORM.Media.Solids.Copper.OFHC_RRR200,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        roughness=data.roughness,
        nR=2,
        dimension=data.pipes.table[data.index_11, 4],
        crossArea=data.pipes.table[data.index_11, 5],
        angle=data.pipes.table[data.index_11, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_11, 1]),
        th_wall=data.pipes.table[data.index_11, 11],
        length=data.pipes.table[data.index_11, 2] + CTAH_ExtraLength.y))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=320,
        origin={94,160})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S12(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_12, 11], integer(data.pipes.table[
        data.index_12, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_12,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_12, 4],
        crossArea=data.pipes.table[data.index_12, 5],
        length=data.pipes.table[data.index_12, 2],
        angle=data.pipes.table[data.index_12, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_12, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_12, 7],
    p_b_start=data.pipes.table[data.index_12, 8],
    T_a_start=data.pipes.table[data.index_12, 9],
    T_b_start=data.pipes.table[data.index_12, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_12, 1])),
    ths_insulation=fill(data.pipes.table[data.index_12, 12], integer(data.pipes.table[
        data.index_12, 1]))*InsulationCF.y) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45,
        origin={78,128})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S13(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_13,
        1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_13, 7],
    p_b_start=data.pipes.table[data.index_13, 8],
    T_a_start=data.pipes.table[data.index_13, 9],
    T_b_start=data.pipes.table[data.index_13, 10],
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_13, 4],
        crossArea=data.pipes.table[data.index_13, 5],
        length=data.pipes.table[data.index_13, 2],
        angle=data.pipes.table[data.index_13, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_13, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_insulation=fill(data.pipes.table[data.index_13, 12], integer(data.pipes.table[
        data.index_13, 1]))*InsulationCF.y,
    ths_wall=fill(data.pipes.table[data.index_13, 11], integer(data.pipes.table[
        data.index_13, 1]))*PipeWallCF.y,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_13, 1])))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={88,42})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S14(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_14, 11], integer(data.pipes.table[
        data.index_14, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_14,
        1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_14, 7],
    p_b_start=data.pipes.table[data.index_14, 8],
    T_a_start=data.pipes.table[data.index_14, 9],
    T_b_start=data.pipes.table[data.index_14, 10],
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_14, 4],
        crossArea=data.pipes.table[data.index_14, 5],
        length=data.pipes.table[data.index_14, 2],
        angle=data.pipes.table[data.index_14, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_14, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_14, 1])),
    ths_insulation=fill(data.pipes.table[data.index_14, 12], integer(data.pipes.table[
        data.index_14, 1]))*InsulationCF.y) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-135,
        origin={74,0})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S15(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_15, 11], integer(data.pipes.table[
        data.index_15, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_15,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_15, 4],
        crossArea=data.pipes.table[data.index_15, 5],
        length=data.pipes.table[data.index_15, 2],
        angle=data.pipes.table[data.index_15, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_15, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_15, 7],
    p_b_start=data.pipes.table[data.index_15, 8],
    T_a_start=data.pipes.table[data.index_15, 9],
    T_b_start=data.pipes.table[data.index_15, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_15, 1])),
    ths_insulation=fill(data.pipes.table[data.index_15, 12], integer(data.pipes.table[
        data.index_15, 1]))*InsulationCF.y) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={54,-20})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S5(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_5, 11], integer(data.pipes.table[
        data.index_5, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_5,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_5, 4],
        crossArea=data.pipes.table[data.index_5, 5],
        length=data.pipes.table[data.index_5, 2],
        angle=data.pipes.table[data.index_5, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_5, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_5, 7],
    p_b_start=data.pipes.table[data.index_5, 8],
    T_a_start=data.pipes.table[data.index_5, 9],
    T_b_start=data.pipes.table[data.index_5, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_5, 1])),
    ths_insulation=fill(data.pipes.table[data.index_5, 12], integer(data.pipes.table[
        data.index_5, 1]))*InsulationCF.y) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-135,
        origin={-78,-36})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S4(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_4, 11], integer(data.pipes.table[
        data.index_4, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_4,
        1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_4, 7],
    p_b_start=data.pipes.table[data.index_4, 8],
    T_a_start=data.pipes.table[data.index_4, 9],
    T_b_start=data.pipes.table[data.index_4, 10],
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_4, 4],
        crossArea=data.pipes.table[data.index_4, 5],
        length=data.pipes.table[data.index_4, 2],
        angle=data.pipes.table[data.index_4, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_4, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_4, 1])),
    ths_insulation=fill(data.pipes.table[data.index_4, 12], integer(data.pipes.table[
        data.index_4, 1]))*InsulationCF.y) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-10})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S3(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_3, 11], integer(data.pipes.table[
        data.index_3, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_3,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_3, 4],
        crossArea=data.pipes.table[data.index_3, 5],
        length=data.pipes.table[data.index_3, 2],
        angle=data.pipes.table[data.index_3, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_3, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_3, 7],
    p_b_start=data.pipes.table[data.index_3, 8],
    T_a_start=data.pipes.table[data.index_3, 9],
    T_b_start=data.pipes.table[data.index_3, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    ths_insulation=fill(data.pipes.table[data.index_3, 12], integer(data.pipes.table[
        data.index_3, 1]))*InsulationCF.y,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_3, 1])))
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={-44,18})));

  Fluid.Pipes.GenericPipe_withWallAndInsulation S2(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_2, 11], integer(data.pipes.table[
        data.index_2, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_2,
        1])),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_2, 4],
        crossArea=data.pipes.table[data.index_2, 5],
        length=data.pipes.table[data.index_2, 2],
        angle=data.pipes.table[data.index_2, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_2, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_2, 7],
    p_b_start=data.pipes.table[data.index_2, 8],
    T_a_start=data.pipes.table[data.index_2, 9],
    T_b_start=data.pipes.table[data.index_2, 10],
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_2, 1])),
    ths_insulation=fill(data.pipes.table[data.index_2, 12], integer(data.pipes.table[
        data.index_2, 1]))*InsulationCF.y) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-28,-2})));

  Fluid.Volumes.ExpansionTank_1Port tank1(
    redeclare package Medium = Medium,
    p_start=data.p_primary,
    use_T_start=true,
    T_start=data.T_hot_primary,
    A=data.tank1_crossArea,
    level_start=0.5*data.tank1_length,
    dheight=data.pipes.table[data.index_16, 2]*sin(data.pipes.table[data.index_16,
        3]*Modelica.Constants.pi/180))
    annotation (Placement(transformation(extent={{-50,196},{-30,216}})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium = Medium, m_flow_nominal=data.m_flow_primary)
    annotation (Placement(transformation(extent={{22,-30},{2,-10}})));
  Fluid.Volumes.SimpleVolume volume(
    redeclare package Medium = Medium,
    p_start=S15.p_b_start,
    T_start=S15.T_b_start,
    use_HeatPort=false,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=0.003))
    annotation (Placement(transformation(extent={{22,-30},{42,-10}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_11[integer(data.pipes.table[
    data.index_11, 1])](each alpha=HTC_CTAH.y, surfaceArea=S11.wall.geometry.crossAreas_1
        [end, :]*CTAHAreaCF.y)
    annotation (Placement(transformation(extent={{102,154},{122,174}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary_11(
      nPorts=integer(data.pipes.table[data.index_11, 1]), T=fill(data.T_ambient,
        integer(data.pipes.table[data.index_11, 1])))
    annotation (Placement(transformation(extent={{154,154},{134,174}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_6[integer(data.pipes.table[
    data.index_6, 1])](each alpha=HTC_Ambient.y, surfaceArea=S6.wall.geometry.crossAreas_1
        [end, :]) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-150,-10})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(
    use_port=false,
    nPorts=integer(data.pipes.table[data.index_6, 1]),
    T=fill(data.T_ambient, integer(data.pipes.table[data.index_6, 1])))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-190,-10})));

  TRANSFORM.Examples.CIET_Facility.Data.Data_nureth data
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  Modelica.Blocks.Sources.Constant FanFrequency(k=22.0) "Hertz"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Modelica.Blocks.Sources.TimeTable PowerTable(timeScale=1, table=[0,0; 11.9,0;
        12,8000; 2424.9,8000; 2425,8500; 2444.9,8500; 2445,7500; 2454.9,7500; 2455,
        8500; 2464.9,8500; 2465,7500; 2494.9,7500; 2495,8500; 2514.9,8500; 2515,
        7500; 2524.9,7500; 2525,8500; 2534.9,8500; 2535,7500; 2544.9,7500; 2545,
        8500; 2554.9,8500; 2555,7500; 2564.9,7500; 2565,8500; 2614.9,8500; 2615,
        7500; 2624.9,7500; 2625,8500; 2644.9,8500; 2645,7500; 2664.9,7500; 2665,
        8500; 2684.9,8500; 2685,7500; 2714.9,7500; 2715,8500; 2744.9,8500; 2745,
        7500; 2754.9,7500; 2755,8500; 2804.9,8500; 2805,7500; 2824.9,7500; 2825,
        8500; 2844.9,8500; 2845,7500; 2854.9,7500; 2855,8500; 2864.9,8500; 2865,
        7500; 2884.9,7500; 2885,8500; 2894.9,8500; 2895,7500; 2904.9,7500; 2905,
        8500; 2924.9,8500; 2925,7500; 2934.9,7500; 2935,8500; 2944.9,8500; 2945,
        7500; 3014.9,7500; 3015,8500; 3044.9,8500; 3045,7500; 3054.9,7500; 3055,
        8500; 3064.9,8500; 3065,7500; 3094.9,7500; 3095,8500; 3164.9,8500; 3165,
        7500; 3174.9,7500; 3175,8500; 3184.9,8500; 3185,7500; 3204.9,7500; 3205,
        8500; 3214.9,8500; 3215,7500; 3224.9,7500; 3225,8500; 3244.9,8500; 3245,
        7500; 3254.9,7500; 3255,8500; 3264.9,8500; 3265,7500; 3284.9,7500; 3285,
        8500; 3304.9,8500; 3305,7500; 3354.9,7500; 3355,8500; 3364.9,8500; 3365,
        7500; 3394.8,7500; 3394.9,8500; 3424.8,8500; 3424.9,7500; 3444.8,7500; 3444.9,
        8500; 3464.8,8500; 3464.9,7500; 3484.8,7500; 3484.9,8500; 3494.8,8500; 3494.9,
        7500; 3544.8,7500; 3544.9,8500; 3554.8,8500; 3554.9,7500; 3564.8,7500; 3564.9,
        8500; 3574.8,8500; 3574.9,7500; 3584.8,7500; 3584.9,8500; 3594.8,8500; 3594.9,
        7500; 3614.8,7500; 3614.9,8500; 3644.8,8500; 3644.9,7500; 3654.8,7500; 3654.9,
        8500; 3664.8,8500; 3664.9,7500; 3684.8,7500; 3684.9,8500; 3714.8,8500; 3714.9,
        7500; 3724.8,7500; 3724.9,8500; 3734.8,8500; 3734.9,7500; 3764.8,7500; 3764.9,
        8500; 3784.8,8500; 3784.9,7500; 3794.8,7500; 3794.9,8500; 3804.8,8500; 3804.9,
        7500; 3814.8,7500; 3814.9,8500; 3824.8,8500; 3824.9,7500; 3834.8,7500; 3834.9,
        8500; 3884.8,8500; 3884.9,7500; 3894.8,7500; 3894.9,8500; 3914.8,8500; 3914.9,
        7500; 3934.8,7500; 3934.9,8500; 3954.8,8500; 3954.9,7500; 3984.8,7500; 3984.9,
        8500; 4014.8,8500; 4014.9,7500; 4024.8,7500; 4024.9,8500; 4074.8,8500; 4074.9,
        7500; 4094.8,7500; 4094.9,8500; 4114.8,8500; 4114.9,7500; 4124.8,7500; 4124.9,
        8500; 4134.8,8500; 4134.9,7500; 4154.8,7500; 4154.9,8500; 4164.8,8500; 4164.9,
        7500; 4174.8,7500; 4174.9,8500; 4194.8,8500; 4194.9,7500; 4204.8,7500; 4204.9,
        8500; 4214.8,8500; 4214.9,7500; 4284.8,7500; 4284.9,8500; 4314.8,8500; 4314.9,
        7500; 4324.8,7500; 4324.9,8500; 4334.8,8500; 4334.9,7500; 4364.8,7500; 4364.9,
        8500; 4434.8,8500; 4434.9,7500; 4444.8,7500; 4444.9,8500; 4454.8,8500; 4454.9,
        7500; 4474.8,7500; 4474.9,8500; 4484.8,8500; 4484.9,7500; 4494.8,7500; 4494.9,
        8500; 4514.8,8500; 4514.9,7500; 4524.8,7500; 4524.9,8500; 4534.8,8500; 4534.9,
        7500; 4554.8,7500; 4554.9,8500; 4574.8,8500; 4574.9,7500; 4624.8,7500; 4624.9,
        8500; 4634.8,8500; 4634.9,7500; 4664.8,7500; 4664.9,8500; 4694.8,8500; 4694.9,
        7500; 4714.8,7500; 4714.9,8500; 4734.8,8500; 4734.9,7500; 4754.8,7500; 4754.9,
        8500; 4764.8,8500; 4764.9,7500; 4814.8,7500; 4814.9,8500; 4824.8,8500; 4824.9,
        7500; 4834.8,7500; 4834.9,8500; 4844.8,8500; 4844.9,7500; 4854.8,7500; 4854.9,
        8500; 4864.8,8500; 4864.9,7500; 4884.8,7500; 4884.9,8500; 4914.8,8500; 4914.9,
        7500; 4924.8,7500; 4924.9,8500; 4934.8,8500; 4934.9,7500; 4954.8,7500; 4954.9,
        8500; 4984.8,8500; 4984.9,7500; 4994.8,7500; 4994.9,8500; 5004.8,8500; 5004.9,
        7500; 5034.8,7500; 5034.9,8500; 5054.8,8500; 5054.9,7500; 5064.8,7500; 5064.9,
        8500; 5074.8,8500; 5074.9,7500; 5084.8,7500; 5084.9,8500; 5094.8,8500; 5094.9,
        7500; 5104.8,7500; 5104.9,8500; 5154.8,8500; 5154.9,7500; 5164.8,7500; 5164.9,
        8500; 5184.8,8500; 5184.9,7500; 5204.8,7500; 5204.9,8500; 5224.8,8500; 5224.9,
        7500; 5254.8,7500; 5254.9,8500; 5284.8,8500; 5284.9,7500; 5294.8,7500; 5294.9,
        8500; 5344.8,8500; 5344.9,7500; 5364.8,7500; 5364.9,8500; 5384.8,8500; 5384.9,
        7500; 5394.8,7500; 5394.9,8500; 5404.8,8500; 5404.9,7500; 5424.8,7500; 5424.9,
        8500; 5434.8,8500; 5434.9,7500; 5444.8,7500; 5444.9,8500; 5464.8,8500; 5464.9,
        7500; 5474.8,7500; 5474.9,8500; 5484.8,8500; 5484.9,7500; 5554.7,7500; 5554.8,
        8500; 5584.7,8500; 5584.8,7500; 5594.7,7500; 5594.8,8500; 5604.7,8500; 5604.8,
        7500; 5634.7,7500; 5634.8,8500; 5704.7,8500; 5704.8,7500; 5714.7,7500; 5714.8,
        8500; 5724.7,8500; 5724.8,7500; 5744.7,7500; 5744.8,8500; 5754.7,8500; 5754.8,
        7500; 5764.7,7500; 5764.8,8500; 5784.7,8500; 5784.8,7500; 5794.7,7500; 5794.8,
        8500; 5804.7,8500; 5804.8,7500; 5824.7,7500; 5824.8,8500; 5844.7,8500; 5844.8,
        7500; 5894.7,7500; 5894.8,8500; 5904.7,8500; 5904.8,7500; 5934.7,7500; 5934.8,
        8500; 5964.7,8500; 5964.8,7500; 5984.7,7500; 5984.8,8500; 6004.7,8500; 6004.8,
        7500; 6024.7,7500; 6024.8,8500; 6034.7,8500; 6034.8,7500; 6084.7,7500; 6084.8,
        8500; 6094.7,8500; 6094.8,7500; 6104.7,7500; 6104.8,8500; 6114.7,8500; 6114.8,
        7500; 6124.7,7500; 6124.8,8500; 6134.7,8500; 6134.8,7500; 6154.7,7500; 6154.8,
        8500; 6184.7,8500; 6184.8,7500; 6194.7,7500; 6194.8,8500; 6204.7,8500; 6204.8,
        7500; 6224.7,7500; 6224.8,8500; 6235.7,8500; 6235.8,8000; 6460.8,8000; 6460.9,
        8500; 6540.8,8500; 6540.9,7500; 6550.8,7500; 6550.9,8500; 6560.7,8500; 6560.8,
        7500; 6570.7,7500; 6570.8,8500; 6580.7,8500; 6580.8,7500; 6590.7,7500; 6590.8,
        8500; 6600.7,8500; 6600.8,7500; 6610.7,7500; 6610.8,8500; 6620.7,8500; 6620.8,
        7500; 6640.7,7500; 6640.8,8500; 6660.7,8500; 6660.8,7500; 6680.7,7500; 6680.8,
        8500; 6710.7,8500; 6710.8,7500; 6720.7,7500; 6720.8,8500; 6740.7,8500; 6740.8,
        7500; 6770.7,7500; 6770.8,8500; 6790.7,8500; 6790.8,7500; 6830.7,7500; 6830.8,
        8500; 6840.7,8500; 6840.8,7500; 6850.7,7500; 6850.8,8500; 6860.7,8500; 6860.8,
        7500; 6910.7,7500; 6910.8,8500; 6940.7,8500; 6940.8,7500; 6950.7,7500; 6950.8,
        8500; 6970.7,8500; 6970.8,7500; 6990.7,7500; 6990.8,8500; 7000.7,8500; 7000.8,
        7500; 7010.7,7500; 7010.8,8500; 7030.7,8500; 7030.8,7500; 7060.7,7500; 7060.8,
        8500; 7070.7,8500; 7070.8,7500; 7080.7,7500; 7080.8,8500; 7130.7,8500; 7130.8,
        7500; 7180.7,7500; 7180.8,8500; 7190.7,8500; 7190.8,7500; 7200.7,7500; 7200.8,
        8500; 7230.7,8500; 7230.8,7500; 7250.7,7500; 7250.8,8500; 7260.7,8500; 7260.8,
        7500; 7320.7,7500; 7320.8,8500; 7330.7,8500; 7330.8,7500; 7340.7,7500; 7340.8,
        8500; 7350.7,8500; 7350.8,7500; 7370.7,7500; 7370.8,8500; 7380.7,8500; 7380.8,
        7500; 7390.7,7500; 7390.8,8500; 7430.7,8500; 7430.8,7500; 7450.7,7500; 7450.8,
        8500; 7480.7,8500; 7480.8,7500; 7520.7,7500; 7520.8,8500; 7540.7,8500; 7540.8,
        7500; 7560.7,7500; 7560.8,8500; 7580.7,8500; 7580.8,7500; 7590.7,7500; 7590.8,
        8500; 7600.7,8500; 7600.8,7500; 7620.7,7500; 7620.8,8500; 7630.7,8500; 7630.8,
        7500; 7640.7,7500; 7640.8,8500; 7650.7,8500; 7650.8,7500; 7670.7,7500; 7670.8,
        8500; 7690.7,8500; 7690.8,7500; 7700.7,7500; 7700.8,8500; 7720.7,8500; 7720.8,
        7500; 7730.7,7500; 7730.8,8500; 7810.7,8500; 7810.8,7500; 7820.7,7500; 7820.8,
        8500; 7830.7,8500; 7830.8,7500; 7840.7,7500; 7840.8,8500; 7850.7,8500; 7850.8,
        7500; 7860.7,7500; 7860.8,8500; 7870.7,8500; 7870.8,7500; 7880.7,7500; 7880.8,
        8500; 7890.7,8500; 7890.8,7500; 7910.7,7500; 7910.8,8500; 7930.7,8500; 7930.8,
        7500; 7950.7,7500; 7950.8,8500; 7980.7,8500; 7980.8,7500; 7990.7,7500; 7990.8,
        8500; 8010.7,8500; 8010.8,7500; 8040.7,7500; 8040.8,8500; 8060.7,8500; 8060.8,
        7500; 8100.7,7500; 8100.8,8500; 8110.7,8500; 8110.8,7500; 8120.7,7500; 8120.8,
        8500; 8130.7,8500; 8130.8,7500; 8180.7,7500; 8180.8,8500; 8210.7,8500; 8210.8,
        7500; 8220.7,7500; 8220.8,8500; 8240.7,8500; 8240.8,7500; 8260.7,7500; 8260.8,
        8500; 8270.7,8500; 8270.8,7500; 8280.7,7500; 8280.8,8500; 8300.7,8500; 8300.8,
        7500; 8330.7,7500; 8330.8,8500; 8340.7,8500; 8340.8,7500; 8350.7,7500; 8350.8,
        8500; 8400.7,8500; 8400.8,7500; 8450.7,7500; 8450.8,8500; 8460.7,8500; 8460.8,
        7500; 8470.7,7500; 8470.8,8500; 8500.7,8500; 8500.8,7500; 8520.7,7500; 8520.8,
        8500; 8530.7,8500; 8530.8,7500; 8590.7,7500; 8590.8,8500; 8600.6,8500; 8600.7,
        7500; 8610.7,7500; 8610.8,8500; 8620.7,8500; 8620.8,7500; 8640.7,7500; 8640.8,
        8500; 8650.7,8500; 8650.8,7500; 8660.7,7500; 8660.8,8500; 8700.6,8500; 8700.7,
        7500; 8720.6,7500; 8720.7,8500; 8750.6,8500; 8750.7,7500; 8790.6,7500; 8790.7,
        8500; 8810.6,8500; 8810.7,7500; 8830.6,7500; 8830.7,8500; 8850.6,8500; 8850.7,
        7500; 8860.6,7500; 8860.7,8500; 8870.6,8500; 8870.7,7500; 8890.6,7500; 8890.7,
        8500; 8900.6,8500; 8900.7,7500; 8910.6,7500; 8910.7,8500; 8920.6,8500; 8920.7,
        7500; 8940.6,7500; 8940.7,8500; 8960.6,8500; 8960.7,7500; 8970.6,7500; 8970.7,
        8500; 8990.6,8500; 8990.7,7500; 9000.6,7500; 9000.7,8500; 9080.6,8500; 9080.7,
        7500; 9090.6,7500; 9090.7,8500; 9100.6,8500; 9100.7,7500; 9110.6,7500; 9110.7,
        8500; 9120.6,8500; 9120.7,7500; 9130.6,7500; 9130.7,8500; 9140.6,8500; 9140.7,
        7500; 9150.6,7500; 9150.7,8500; 9160.6,8500; 9160.7,7500; 9180.6,7500; 9180.7,
        8500; 9200.6,8500; 9200.7,7500; 9220.6,7500; 9220.7,8500; 9250.6,8500; 9250.7,
        7500; 9260.6,7500; 9260.7,8500; 9280.6,8500; 9280.7,7500; 9310.6,7500; 9310.7,
        8500; 9330.6,8500; 9330.7,7500; 9370.6,7500; 9370.7,8500; 9380.6,8500; 9380.7,
        7500; 9390.6,7500; 9390.7,8500; 9400.6,8500; 9400.7,7500; 9450.6,7500; 9450.7,
        8500; 9480.6,8500; 9480.7,7500; 9490.6,7500; 9490.7,8500; 9510.6,8500; 9510.7,
        7500; 9530.6,7500; 9530.7,8500; 9540.6,8500; 9540.7,7500; 9550.6,7500; 9550.7,
        8500; 9570.6,8500; 9570.7,7500; 9600.6,7500; 9600.7,8500; 9610.6,8500; 9610.7,
        7500; 9620.6,7500; 9620.7,8500; 9670.6,8500; 9670.7,7500; 9720.6,7500; 9720.7,
        8500; 9730.6,8500; 9730.7,7500; 9740.6,7500; 9740.7,8500; 9770.6,8500; 9770.7,
        7500; 9790.6,7500; 9790.7,8500; 9800.6,8500; 9800.7,7500; 9860.6,7500; 9860.7,
        8500; 9870.6,8500; 9870.7,7500; 9880.6,7500; 9880.7,8500; 9890.6,8500; 9890.7,
        7500; 9910.6,7500; 9910.7,8500; 9920.6,8500; 9920.7,7500; 9930.6,7500; 9930.7,
        8500; 9970.6,8500; 9970.7,7500; 9990.6,7500; 9990.7,8500; 10021,8500; 10021,
        7500; 10061,7500; 10061,8500; 10081,8500; 10081,7500; 10101,7500; 10101,
        8500; 10121,8500; 10121,7500; 10131,7500; 10131,8500; 10141,8500; 10141,
        7500; 10161,7500; 10161,8500; 10171,8500; 10171,7500; 10181,7500; 10181,
        8500; 10191,8500; 10191,7500; 10211,7500; 10211,8500; 10231,8500; 10231,
        7500; 10241,7500; 10241,8500; 10261,8500; 10261,7500; 10272,7500; 10272,
        8000; 10543,8000; 10543,8500; 10583,8500; 10583,7500; 10593,7500; 10593,
        8500; 10633,8500; 10633,7500; 10653,7500; 10653,8500; 10683,8500; 10683,
        7500; 10693,7500; 10693,8500; 10703,8500; 10703,7500; 10713,7500; 10713,
        8500; 10733,8500; 10733,7500; 10743,7500; 10743,8500; 10753,8500; 10753,
        7500; 10763,7500; 10763,8500; 10823,8500; 10823,7500; 10853,7500; 10853,
        8500; 10863,8500; 10863,7500; 10893,7500; 10893,8500; 10903,8500; 10903,
        7500; 10913,7500; 10913,8500; 10933,8500; 10933,7500; 10943,7500; 10943,
        8500; 10963,8500; 10963,7500; 10993,7500; 10993,8500; 11003,8500; 11003,
        7500; 11013,7500; 11013,8500; 11042,8500; 11043,7500; 11052,7500; 11053,
        8500; 11082,8500; 11083,7500; 11092,7500; 11093,8500; 11112,8500; 11113,
        7500; 11162,7500; 11163,8500; 11192,8500; 11193,7500; 11222,7500; 11223,
        8500; 11232,8500; 11233,7500; 11252,7500; 11253,8500; 11272,8500; 11273,
        7500; 11282,7500; 11283,8500; 11302,8500; 11303,7500; 11312,7500; 11313,
        8500; 11322,8500; 11323,7500; 11342,7500; 11343,8500; 11392,8500; 11393,
        7500; 11442,7500; 11443,8500; 11462,8500; 11463,7500; 11492,7500; 11493,
        8500; 11502,8500; 11503,7500; 11512,7500; 11513,8500; 11522,8500; 11523,
        7500; 11532,7500; 11533,8500; 11542,8500; 11543,7500; 11562,7500; 11563,
        8500; 11582,8500; 11583,7500; 11592,7500; 11593,8500; 11602,8500; 11603,
        7500; 11612,7500; 11613,8500; 11632,8500; 11633,7500; 11652,7500; 11653,
        8500; 11682,8500; 11683,7500; 11702,7500; 11703,8500; 11712,8500; 11713,
        7500; 11762,7500; 11763,8500; 11772,8500; 11773,7500; 11792,7500; 11793,
        8500; 11802,8500; 11803,7500; 11812,7500; 11813,8500; 11822,8500; 11823,
        7500; 11832,7500; 11833,8500; 11842,8500; 11843,7500; 11862,7500; 11863,
        8500; 11872,8500; 11873,7500; 11912,7500; 11913,8500; 11922,8500; 11923,
        7500; 11962,7500; 11963,8500; 12012,8500; 12013,7500; 12022,7500; 12023,
        8500; 12062,8500; 12063,7500; 12082,7500; 12083,8500; 12112,8500; 12113,
        7500; 12122,7500; 12123,8500; 12132,8500; 12133,7500; 12142,7500; 12143,
        8500; 12162,8500; 12163,7500; 12172,7500; 12173,8500; 12182,8500; 12183,
        7500; 12192,7500; 12193,8500; 12252,8500; 12253,7500; 12282,7500; 12283,
        8500; 12292,8500; 12293,7500; 12322,7500; 12323,8500; 12332,8500; 12333,
        7500; 12342,7500; 12343,8500; 12362,8500; 12363,7500; 12372,7500; 12373,
        8500; 12392,8500; 12393,7500; 12422,7500; 12423,8500; 12432,8500; 12433,
        7500; 12442,7500; 12443,8500; 12472,8500; 12473,7500; 12482,7500; 12483,
        8500; 12512,8500; 12513,7500; 12522,7500; 12523,8500; 12542,8500; 12543,
        7500; 12592,7500; 12593,8500; 12622,8500; 12623,7500; 12652,7500; 12653,
        8500; 12662,8500; 12663,7500; 12682,7500; 12683,8500; 12702,8500; 12703,
        7500; 12712,7500; 12713,8500; 12732,8500; 12733,7500; 12742,7500; 12743,
        8500; 12752,8500; 12753,7500; 12772,7500; 12773,8500; 12822,8500; 12823,
        7500; 12872,7500; 12873,8500; 12892,8500; 12893,7500; 12922,7500; 12923,
        8500; 12932,8500; 12933,7500; 12942,7500; 12943,8500; 12952,8500; 12953,
        7500; 12962,7500; 12963,8500; 12972,8500; 12973,7500; 12992,7500; 12993,
        8500; 13012,8500; 13013,7500; 13022,7500; 13023,8500; 13032,8500; 13033,
        7500; 13042,7500; 13043,8500; 13062,8500; 13063,7500; 13082,7500; 13083,
        8500; 13112,8500; 13113,7500; 13132,7500; 13133,8500; 13142,8500; 13142,
        7500; 13192,7500; 13192,8500; 13202,8500; 13202,7500; 13222,7500; 13222,
        8500; 13232,8500; 13232,7500; 13242,7500; 13242,8500; 13252,8500; 13252,
        7500; 13262,7500; 13262,8500; 13272,8500; 13272,7500; 13292,7500; 13292,
        8500; 13302,8500; 13302,7500; 13342,7500; 13342,8500; 13352,8500; 13352,
        7500; 13392,7500; 13392,8500; 13442,8500; 13442,7500; 13452,7500; 13452,
        8500; 13492,8500; 13492,7500; 13512,7500; 13512,8500; 13542,8500; 13542,
        7500; 13552,7500; 13552,8500; 13562,8500; 13562,7500; 13572,7500; 13572,
        8500; 13592,8500; 13592,7500; 13602,7500; 13602,8500; 13612,8500; 13612,
        7500; 13622,7500; 13622,8500; 13682,8500; 13682,7500; 13712,7500; 13712,
        8500; 13722,8500; 13722,7500; 13752,7500; 13752,8500; 13762,8500; 13762,
        7500; 13772,7500; 13772,8500; 13792,8500; 13792,7500; 13802,7500; 13802,
        8500; 13822,8500; 13822,7500; 13852,7500; 13852,8500; 13862,8500; 13862,
        7500; 13872,7500; 13872,8500; 13902,8500; 13902,7500; 13912,7500; 13912,
        8500; 13942,8500; 13942,7500; 13952,7500; 13952,8500; 13972,8500; 13972,
        7500; 14022,7500; 14022,8500; 14052,8500; 14052,7500; 14082,7500; 14082,
        8500; 14092,8500; 14092,7500; 14112,7500; 14112,8500; 14132,8500; 14132,
        7500; 14142,7500; 14142,8500; 14162,8500; 14162,7500; 14172,7500; 14172,
        8500; 14182,8500; 14182,7500; 14202,7500; 14202,8500; 14252,8500; 14252,
        7500; 14302,7500; 14302,8500; 14322,8500; 14322,7500; 14352,7500; 14352,
        8500; 14362,8500; 14362,7500; 14372,7500; 14372,8500; 14382,8500; 14382,
        7500; 14392,7500; 14392,8500; 14402,8500; 14402,7500; 14422,7500; 14422,
        8500; 14442,8500; 14442,7500; 14452,7500; 14452,8500; 14462,8500; 14462,
        7500; 14472,7500; 14472,8500; 14492,8500; 14492,7500; 14512,7500; 14512,
        8500; 14542,8500; 14542,7500; 14562,7500; 14562,8500; 14572,8500; 14572,
        7500; 14622,7500; 14622,8500; 14632,8500; 14632,7500; 14652,7500; 14652,
        8500; 14662,8500; 14662,7500; 14672,7500; 14672,8500; 14682,8500; 14682,
        7500; 14692,7500; 14692,8500; 14702,8500; 14702,7500; 14722,7500; 14722,
        8500; 14732,8500; 14732,7500; 14772,7500; 14772,8500; 14782,8500; 14782,
        7500; 14822,7500; 14822,8500; 14833,8500; 14834,8000; 15191,8000; 15191,
        7500; 15231,7500; 15231,8500; 15241,8500; 15241,8000; 15251,8000; 15251,
        7500; 15261,7500; 15261,8500; 15271,8500; 15271,7500; 15291,7500; 15291,
        8500; 15301,8500; 15301,7500; 15311,7500; 15311,8500; 15321,8500; 15321,
        8000; 15331,8000; 15331,8500; 15341,8500; 15341,8000; 15351,8000; 15351,
        8500; 15371,8500; 15371,7500; 15391,7500; 15391,8000; 15401,8000; 15401,
        8500; 15411,8500; 15411,8000; 15421,8000; 15421,7500; 15441,7500; 15441,
        8000; 15461,8000; 15461,7500; 15471,7500; 15471,8500; 15501,8500; 15501,
        8000; 15511,8000; 15511,8500; 15521,8500; 15521,7500; 15531,7500; 15531,
        8000; 15551,8000; 15551,8500; 15561,8500; 15561,8000; 15591,8000; 15591,
        8500; 15631,8500; 15631,7500; 15641,7500; 15641,8000; 15651,8000; 15651,
        8500; 15661,8500; 15661,7500; 15671,7500; 15671,8500; 15691,8500; 15691,
        7500; 15701,7500; 15701,8500; 15711,8500; 15711,7500; 15721,7500; 15721,
        8000; 15731,8000; 15731,7500; 15741,7500; 15741,8000; 15751,8000; 15751,
        7500; 15771,7500; 15771,8500; 15791,8500; 15791,8000; 15801,8000; 15801,
        7500; 15811,7500; 15811,8000; 15821,8000; 15821,8500; 15841,8500; 15841,
        8000; 15861,8000; 15861,8500; 15871,8500; 15871,7500; 15901,7500; 15901,
        8000; 15911,8000; 15911,7500; 15921,7500; 15921,8500; 15931,8500; 15931,
        8000; 15951,8000; 15951,7500; 15961,7500; 15961,8000; 15991,8000; 15991,
        7500; 16031,7500; 16031,8500; 16041,8500; 16041,8000; 16051,8000; 16051,
        7500; 16061,7500; 16061,8500; 16071,8500; 16071,7500; 16091,7500; 16091,
        8500; 16101,8500; 16101,7500; 16111,7500; 16111,8500; 16121,8500; 16121,
        8000; 16131,8000; 16131,8500; 16141,8500; 16141,8000; 16151,8000; 16151,
        8500; 16171,8500; 16171,7500; 16191,7500; 16191,8000; 16201,8000; 16201,
        8500; 16211,8500; 16211,8000; 16221,8000; 16221,7500; 16241,7500; 16241,
        8000; 16261,8000; 16261,7500; 16271,7500; 16271,8500; 16301,8500; 16301,
        8000; 16311,8000; 16311,8500; 16321,8500; 16321,7500; 16331,7500; 16331,
        8000; 16351,8000; 16351,8500; 16361,8500; 16361,8000; 16391,8000; 16391,
        8500; 16431,8500; 16431,7500; 16441,7500; 16441,8000; 16451,8000; 16451,
        8500; 16461,8500; 16461,7500; 16471,7500; 16471,8500; 16491,8500; 16491,
        7500; 16501,7500; 16501,8500; 16511,8500; 16511,7500; 16521,7500; 16521,
        8000; 16531,8000; 16531,7500; 16541,7500; 16541,8000; 16551,8000; 16551,
        7500; 16571,7500; 16571,8500; 16591,8500; 16591,8000; 16601,8000; 16601,
        7500; 16611,7500; 16611,8000; 16621,8000; 16621,8500; 16641,8500; 16641,
        8000; 16661,8000; 16661,8500; 16671,8500; 16671,7500; 16701,7500; 16701,
        8000; 16711,8000; 16711,7500; 16721,7500; 16721,8500; 16731,8500; 16731,
        8000; 16751,8000; 16751,7500; 16761,7500; 16761,8000; 16791,8000; 16791,
        7500; 16831,7500; 16831,8500; 16841,8500; 16841,8000; 16851,8000; 16851,
        7500; 16861,7500; 16861,8500; 16871,8500; 16871,7500; 16891,7500; 16891,
        8500; 16901,8500; 16901,7500; 16911,7500; 16911,8500; 16921,8500; 16921,
        8000; 16931,8000; 16931,8500; 16941,8500; 16941,8000; 16951,8000; 16951,
        8500; 16971,8500; 16971,7500; 16991,7500; 16991,8000; 17001,8000; 17001,
        8500; 17011,8500; 17011,8000; 17021,8000; 17021,7500; 17041,7500; 17041,
        8000; 17061,8000; 17061,7500; 17071,7500; 17071,8500; 17101,8500; 17101,
        8000; 17111,8000; 17111,8500; 17121,8500; 17121,7500; 17131,7500; 17131,
        8000; 17151,8000; 17151,8500; 17161,8500; 17161,8000; 17191,8000; 17191,
        8500; 17231,8500; 17231,7500; 17241,7500; 17241,8000; 17251,8000; 17251,
        8500; 17261,8500; 17261,7500; 17271,7500; 17271,8500; 17291,8500; 17291,
        7500; 17301,7500; 17301,8500; 17311,8500; 17311,7500; 17321,7500; 17321,
        8000; 17331,8000; 17331,7500; 17341,7500; 17341,8000; 17351,8000; 17351,
        7500; 17371,7500; 17371,8500; 17391,8500; 17391,8000; 17401,8000; 17401,
        7500; 17411,7500; 17411,8000; 17421,8000; 17421,8500; 17441,8500; 17441,
        8000; 17461,8000; 17461,8500; 17471,8500; 17471,7500; 17501,7500; 17501,
        8000; 17502,8000; 20000,8000])
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Modelica.Blocks.Sources.Constant InsulationCF(k=1)
    "Correction Factor for Insulation"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Sources.Constant PipeWallCF(k=1)
    "Correction Factor for Insulation"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Sources.Constant HTC_Ambient(k=45)
    "Correction Factor for Insulation"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Modelica.Blocks.Sources.Constant HTC_CTAH(k=242)
    "Correction Factor for Insulation"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.Convection convection_1[
    integer(data.pipes.table[data.index_1, 1])](surfaceArea=0.5, each alpha=
        HTC_Ambient.y) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,60})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi
    boundaryAmbient(
    use_port=false,
    nPorts=integer(data.pipes.table[data.index_1, 1]),
    T=fill(data.T_ambient, integer(data.pipes.table[data.index_1, 1])))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,86})));
  TRANSFORM.Fluid.Pipes.GenericPipe_withWallAndInsulation S1(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    ths_wall=fill(data.pipes.table[data.index_1, 11], integer(data.pipes.table[
        data.index_1, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_1,
        1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_1, 7],
    p_b_start=data.pipes.table[data.index_1, 8],
    T_a_start=data.pipes.table[data.index_1, 9],
    T_b_start=data.pipes.table[data.index_1, 10],
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    alphas_ambient=fill(HTC_Ambient.y, integer(data.pipes.table[data.index_1, 1])),
    ths_insulation=fill(data.pipes.table[data.index_1, 12], integer(data.pipes.table[
        data.index_1, 1]))*InsulationCF.y,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1, 4],
        crossArea=data.pipes.table[data.index_1, 5],
        length=data.pipes.table[data.index_1, 2],
        angle=data.pipes.table[data.index_1, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1, 1]),
        nSurfaces=1),
    use_heatPort_addWall=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-12,-20})));

  Modelica.Blocks.Sources.Constant CTAH_ExtraLength(k=0.0)
    "Correction Factor for CTAH Length (m)"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_withWall S6(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    use_HeatTransferOuter=true,
    exposeState_outerWall=true,
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_11, 7],
    p_b_start=data.pipes.table[data.index_11, 8],
    T_a_start=data.pipes.table[data.index_11, 9],
    T_b_start=data.pipes.table[data.index_11, 10],
    redeclare package Material = TRANSFORM.Media.Solids.SS304,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_6, 4],
        crossArea=data.pipes.table[data.index_6, 5],
        length=data.pipes.table[data.index_6, 2],
        angle=data.pipes.table[data.index_6, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_6, 1]),
        th_wall=data.pipes.table[data.index_6, 11],
        nR=2,
        nSurfaces=2,
        surfaceArea={Modelica.Constants.pi*1.50*0.0254*S6.geometry.length,0.3927}),
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_DittusBoelter_Simple
        (
        A0=0.04179424,
        B0=0.836031,
        C0=0.3333333),
    use_HeatTransfer=true,
    redeclare model InternalHeatModel_wall =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gen=(PowerTable.y)/integer(data.pipes.table[data.index_6, 1])/S6.geometry.nR))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-108,-10})));

  TRANSFORM.HeatAndMassTransfer.Volumes.UnitVolume volume1[integer(data.pipes.table[
    data.index_6, 1])](
    d=Material_wall.density_T(150 + 273.15),
    cp=Material_wall.specificHeatCapacityCp_T(150 + 273.15),
    V=3.120/Material_wall.density_T(150 + 273.15))
    annotation (Placement(transformation(extent={{-160,22},{-140,42}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume2(
    redeclare package Medium = Medium,
    p_start=S15.p_b_start,
    T_start=S15.T_b_start,
    use_HeatPort=false,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.002))
    annotation (Placement(transformation(extent={{82,154},{62,174}})));
  Modelica.Blocks.Sources.Constant CTAHAreaCF(k=1.0125)
    "Correction Factor for HT area in CTAH"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(
    printResult=false,
    n=1,
    x={RTD40})
    annotation (Placement(transformation(extent={{180,240},{200,260}})));
equation
  connect(S8.port_a, S7.port_b) annotation (Line(points={{-81,105.34},{-81,28},
          {-78.6031,28},{-78.6031,25.4202}},color={0,127,255}));
  connect(S9.port_b, S10.port_a) annotation (Line(points={{-44,138},{40.9289,
          138},{40.9289,150.929}},
                              color={0,127,255}));
  connect(S12.port_b, S13.port_a) annotation (Line(points={{85.0711,120.929},{
          88,120.929},{88,52}},
                             color={0,127,255}));
  connect(S14.port_a, S13.port_b) annotation (Line(points={{81.0711,7.07107},{
          81.0711,7.5355},{88,7.5355},{88,32}},
                                        color={0,127,255}));
  connect(S15.port_a, S14.port_b) annotation (Line(points={{64,-20},{64,
          -7.07107},{66.9289,-7.07107}},
                               color={0,127,255}));
  connect(S4.port_b, S5.port_a) annotation (Line(points={{-70,-10},{-70,
          -28.9289},{-70.9289,-28.9289}},
                                color={0,127,255}));
  connect(pump_SimpleMassFlow.port_a, volume.port_a)
    annotation (Line(points={{22,-20},{26,-20}}, color={0,127,255}));
  connect(volume.port_b, S15.port_b)
    annotation (Line(points={{38,-20},{44,-20}}, color={0,127,255}));
  connect(S11.heatPorts, convection_11.port_a) annotation (Line(points={{97.2139,
          163.83},{102,163.83},{102,164},{105,164}}, color={191,0,0}));
  connect(convection_11.port_b, boundary_11.port)
    annotation (Line(points={{119,164},{134,164}}, color={191,0,0}));
  connect(boundary.port, convection_6.port_b)
    annotation (Line(points={{-180,-10},{-157,-10}}, color={191,0,0}));
  connect(S8.port_b, S9.port_a) annotation (Line(points={{-71,122.66},{-71,138},
          {-64,138}}, color={0,127,255}));
  connect(S2.port_b, S3.port_a) annotation (Line(points={{-28,8},{-28,25.0711},
          {-36.9289,25.0711}},color={0,127,255}));
  connect(S3.port_b, S4.port_a) annotation (Line(points={{-51.0711,10.9289},{
          -51.0711,9.46445},{-50,9.46445},{-50,-10}},
                                             color={0,127,255}));
  connect(S11.port_b, S12.port_a) annotation (Line(points={{101.66,153.572},{
          101.66,154},{102,154},{102,142},{70,142},{70,135.071},{70.9289,
          135.071}},
        color={0,127,255}));
  connect(tank1.port, S10.port_a) annotation (Line(points={{-40,197.6},{-40,138},
          {40.9289,138},{40.9289,150.929}}, color={0,127,255}));
  connect(S2.port_a, S1.port_b) annotation (Line(points={{-28,-12},{-26,-12},{-26,
          -20},{-22,-20}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, S1.port_a)
    annotation (Line(points={{2,-20},{-2,-20}}, color={0,127,255}));
  connect(S1.heatPorts_addWall, thermalMass.port_a) annotation (Line(points={{-15,
          -16.8},{-15,-8.4},{-6.66134e-16,-8.4},{-6.66134e-16,-2}}, color={191,0,
          0}));
  connect(convection_1.port_b, boundaryAmbient.port)
    annotation (Line(points={{0,67},{0,76}}, color={191,0,0}));
  connect(thermalMass.port_b, thermalMass1.port_a)
    annotation (Line(points={{0,18},{0,28}}, color={191,0,0}));
  connect(convection_1.port_a, thermalMass1.port_b)
    annotation (Line(points={{0,53},{0,48}}, color={191,0,0}));
  connect(S7.port_a, S6.port_b) annotation (Line(points={{-97.3969,18.5798},{
          -108,18.5798},{-108,0}},
                              color={0,127,255}));
  connect(S5.port_b, S6.port_a) annotation (Line(points={{-85.0711,-43.0711},{
          -108,-43.0711},{-108,-20}},
                                 color={0,127,255}));
  connect(convection_6.port_a, S6.heatPorts)
    annotation (Line(points={{-143,-10},{-113,-10}}, color={191,0,0}));
  connect(volume1.port, S6.heatPorts_add[:, 1]) annotation (Line(points={{-150,22},
          {-120,22},{-120,-7},{-108,-7}}, color={191,0,0}));
  connect(S10.port_b, volume2.port_b) annotation (Line(points={{55.0711,165.071},
          {59.5356,165.071},{59.5356,164},{66,164}}, color={0,127,255}));
  connect(volume2.port_a, S11.port_a) annotation (Line(points={{78,164},{82,164},
          {82,166.428},{86.3396,166.428}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-120},{200,
            260}}), graphics={Text(
          extent={{138,142},{140,142}},
          lineColor={28,108,200},
          textString="Old Correlation: 1122.3*((0.006295784*1.225*FanFrequency.y)^0.7928)")}),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    Documentation(info="<html>
<p>Dynamic model of the University of California - Berkeley&apos;s Compact Integral Effects Test facility (CIET). CIET is as an integral effects test for a fluoride salt-cooled high temperature reactors (FHR). The facility was designed to match the transient thermal hydraulic response of a prototypical FHR during forced and natural circulation for the purpose of code validation.<span style=\"color: #ff0000;\"> </span>It uses Dowtherm A as a simulant heat transfer fluid for molten salt, matching the Reynolds, Grashof, Prandtl, and Froude numbers at much lower temperatures.</p>
<p>This model was created for steady state and frequency response tests. More details can be found in de Wet et. al. 2019 (Source 1).</p>
<p>Source 1:</p>
<p>1. Wet, Dane de, Michael Scott Greenwood, Christopher Morris Poresky, James C. Kendrick, and Per F. Peterson. 2019. &ldquo;A Frequency Response Approach to Model Validation for the Compact Integral Effects Test Facility in TRANSFORM.&rdquo; In <i>Proceedings of the 18th International Topical Meeting on Nuclear Reactor Thermal Hydrualics (NURETH-18)</i>. Portland, OR: American Nuclear Society.</p>
</html>"));
end CIET_nureth;
