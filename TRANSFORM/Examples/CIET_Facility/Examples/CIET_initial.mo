within TRANSFORM.Examples.CIET_Facility.Examples;
model CIET_initial "Initial approach to modeling CIET"
  extends TRANSFORM.Icons.Example;
  package Medium = TRANSFORM.Media.Fluids.DOWTHERM.LinearDOWTHERM_A_95C;
  package Material_wall = TRANSFORM.Media.Solids.SS304_TRACE;
  package Material_insulation =
      TRANSFORM.Media.Solids.FiberGlassGeneric;
  SI.Power Q_heater_fluid = -sum(wall_1.port_a.Q_flow);
  SI.Power Q_heater_ambient = -sum(wall_1.port_b.Q_flow);
  SI.Power Q_insulation = sum(_1a.boundary.port.Q_flow)+
sum(_1b.boundary.port.Q_flow)+
sum(_2.boundary.port.Q_flow)+
sum(_2a.boundary.port.Q_flow)+
sum(_3.boundary.port.Q_flow)+
sum(_4.boundary.port.Q_flow)+
sum(_5.boundary.port.Q_flow)+
sum(_6.boundary.port.Q_flow)+
sum(_6a.boundary.port.Q_flow)+
sum(_8a.boundary.port.Q_flow)+
sum(_8.boundary.port.Q_flow)+
sum(_9.boundary.port.Q_flow)+
sum(_10.boundary.port.Q_flow)+
sum(_11.boundary.port.Q_flow)+
sum(_12.boundary.port.Q_flow)+
sum(_13.boundary.port.Q_flow)+
sum(_14.boundary.port.Q_flow)+
sum(_14a.boundary.port.Q_flow)+
sum(_15.boundary.port.Q_flow)+
sum(_16.boundary.port.Q_flow)+
sum(_17.boundary.port.Q_flow)+
sum(_18.boundary.port.Q_flow);
  SI.Power Q_ctah = sum(_7a.heatPorts.Q_flow)+sum(_7b.heatPorts.Q_flow);
  Fluid.Pipes.GenericPipe_MultiTransferSurface _1(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1, 4],
        crossArea=data.pipes.table[data.index_1, 5],
        length=data.pipes.table[data.index_1, 2],
        angle=data.pipes.table[data.index_1, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_1, 7],
    p_b_start=data.pipes.table[data.index_1, 8],
    T_a_start=data.pipes.table[data.index_1, 9],
    T_b_start=data.pipes.table[data.index_1, 10],
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,-50})));
  Data.Data_initial data
    annotation (Placement(transformation(extent={{134,42},{154,62}})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _1b(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1b, 4],
        crossArea=data.pipes.table[data.index_1b, 5],
        length=data.pipes.table[data.index_1b, 2],
        angle=data.pipes.table[data.index_1b, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1b, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_1b, 7],
    p_b_start=data.pipes.table[data.index_1b, 8],
    T_a_start=data.pipes.table[data.index_1b, 9],
    T_b_start=data.pipes.table[data.index_1b, 10],
    ths_wall=fill(data.pipes.table[data.index_1b, 11], integer(data.pipes.table[data.index_1b, 1])),
    ths_insulation=fill(data.pipes.table[data.index_1b, 12], integer(data.pipes.table[data.index_1b, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_1b, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,-74})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _1a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1a, 4],
        crossArea=data.pipes.table[data.index_1a, 5],
        length=data.pipes.table[data.index_1a, 2],
        angle=data.pipes.table[data.index_1a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1a, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_1a, 7],
    p_b_start=data.pipes.table[data.index_1a, 8],
    T_a_start=data.pipes.table[data.index_1a, 9],
    T_b_start=data.pipes.table[data.index_1a, 10],
    ths_wall=fill(data.pipes.table[data.index_1a, 11], integer(data.pipes.table[data.index_1a, 1])),
    ths_insulation=fill(data.pipes.table[data.index_1a, 12], integer(data.pipes.table[data.index_1a, 1])),
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_1a, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,-26})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _2(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_2, 11], integer(data.pipes.table[data.index_2, 1])),
    ths_insulation=fill(data.pipes.table[data.index_2, 12], integer(data.pipes.table[data.index_2, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_2, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,0})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _2a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_2a, 4],
        crossArea=data.pipes.table[data.index_2a, 5],
        length=data.pipes.table[data.index_2a, 2],
        angle=data.pipes.table[data.index_2a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_2a, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_2a, 7],
    p_b_start=data.pipes.table[data.index_2a, 8],
    T_a_start=data.pipes.table[data.index_2a, 9],
    T_b_start=data.pipes.table[data.index_2a, 10],
            ths_wall=fill(data.pipes.table[data.index_2a, 11], integer(data.pipes.table[data.index_2a, 1])),
    ths_insulation=fill(data.pipes.table[data.index_2a, 12], integer(data.pipes.table[data.index_2a, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_2a, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,26})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _4(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_4, 4],
        crossArea=data.pipes.table[data.index_4, 5],
        length=data.pipes.table[data.index_4, 2],
        angle=data.pipes.table[data.index_4, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_4, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_4, 7],
    p_b_start=data.pipes.table[data.index_4, 8],
    T_a_start=data.pipes.table[data.index_4, 9],
    T_b_start=data.pipes.table[data.index_4, 10],
    ths_wall=fill(data.pipes.table[data.index_4, 11], integer(data.pipes.table[data.index_4, 1])),
    ths_insulation=fill(data.pipes.table[data.index_4, 12], integer(data.pipes.table[data.index_4, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_4, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-45,
        origin={-98,78})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _3(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_3, 11], integer(data.pipes.table[data.index_3, 1])),
    ths_insulation=fill(data.pipes.table[data.index_3, 12], integer(data.pipes.table[data.index_3, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_3, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,50})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _5(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_5, 11], integer(data.pipes.table[data.index_5, 1])),
    ths_insulation=fill(data.pipes.table[data.index_5, 12], integer(data.pipes.table[data.index_5, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_5, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,100})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _6(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_6, 4],
        crossArea=data.pipes.table[data.index_6, 5],
        length=data.pipes.table[data.index_6, 2],
        angle=data.pipes.table[data.index_6, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_6, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_6, 7],
    p_b_start=data.pipes.table[data.index_6, 8],
    T_a_start=data.pipes.table[data.index_6, 9],
    T_b_start=data.pipes.table[data.index_6, 10],
    ths_wall=fill(data.pipes.table[data.index_6, 11], integer(data.pipes.table[data.index_6, 1])),
    ths_insulation=fill(data.pipes.table[data.index_6, 12], integer(data.pipes.table[data.index_6, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_6, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={64,116})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _6a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_6a, 4],
        crossArea=data.pipes.table[data.index_6a, 5],
        length=data.pipes.table[data.index_6a, 2],
        angle=data.pipes.table[data.index_6a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_6a, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_6a, 7],
    p_b_start=data.pipes.table[data.index_6a, 8],
    T_a_start=data.pipes.table[data.index_6a, 9],
    T_b_start=data.pipes.table[data.index_6a, 10],
    ths_wall=fill(data.pipes.table[data.index_6a, 11], integer(data.pipes.table[data.index_6a, 1])),
    ths_insulation=fill(data.pipes.table[data.index_6a, 12], integer(data.pipes.table[data.index_6a, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_6a, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={84,136})));
  Fluid.Pipes.GenericPipe_withWall             _7a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_7a, 7],
    p_b_start=data.pipes.table[data.index_7a, 8],
    T_a_start=data.pipes.table[data.index_7a, 9],
    T_b_start=data.pipes.table[data.index_7a, 10],
    redeclare package Material = Media.Solids.Copper.OFHC_RRR200,
    use_HeatTransferOuter=true,
    exposeState_outerWall=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_7a, 4],
        crossArea=data.pipes.table[data.index_7a, 5],
        length=data.pipes.table[data.index_7a, 2],
        angle=data.pipes.table[data.index_7a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_7a, 1]),
        th_wall=data.pipes.table[data.index_7a, 11],
        nR=2),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={108,124})));
  Fluid.Pipes.GenericPipe_withWall             _7b(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_7b, 7],
    p_b_start=data.pipes.table[data.index_7b, 8],
    T_a_start=data.pipes.table[data.index_7b, 9],
    T_b_start=data.pipes.table[data.index_7b, 10],
    use_HeatTransferOuter=true,
    exposeState_outerWall=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_7b, 4],
        crossArea=data.pipes.table[data.index_7b, 5],
        length=data.pipes.table[data.index_7b, 2],
        angle=data.pipes.table[data.index_7b, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_7b, 1]),
        th_wall=data.pipes.table[data.index_7b, 11],
        nR=2),
    redeclare package Material = Media.Solids.Copper.OFHC_RRR200,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal)
              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={90,104})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _8a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_8a, 4],
        crossArea=data.pipes.table[data.index_8a, 5],
        length=data.pipes.table[data.index_8a, 2],
        angle=data.pipes.table[data.index_8a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_8a, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_8a, 7],
    p_b_start=data.pipes.table[data.index_8a, 8],
    T_a_start=data.pipes.table[data.index_8a, 9],
    T_b_start=data.pipes.table[data.index_8a, 10],
    ths_wall=fill(data.pipes.table[data.index_8a, 11], integer(data.pipes.table[data.index_8a, 1])),
    ths_insulation=fill(data.pipes.table[data.index_8a, 12], integer(data.pipes.table[data.index_8a, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_8a, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={76,80})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _8(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_8, 11], integer(data.pipes.table[data.index_8, 1])),
    ths_insulation=fill(data.pipes.table[data.index_8, 12], integer(data.pipes.table[data.index_8, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_8, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={76,50})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _9(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_9, 11], integer(data.pipes.table[data.index_9, 1])),
    ths_insulation=fill(data.pipes.table[data.index_9, 12], integer(data.pipes.table[data.index_9, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_9, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45,
        origin={88,26})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _10(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_10, 11], integer(data.pipes.table[data.index_10, 1])),
    ths_insulation=fill(data.pipes.table[data.index_10, 12], integer(data.pipes.table[data.index_10, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_10, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={104,-10})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _11(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_11, 4],
        crossArea=data.pipes.table[data.index_11, 5],
        length=data.pipes.table[data.index_11, 2],
        angle=data.pipes.table[data.index_11, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_11, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_11, 7],
    p_b_start=data.pipes.table[data.index_11, 8],
    T_a_start=data.pipes.table[data.index_11, 9],
    T_b_start=data.pipes.table[data.index_11, 10],
    ths_wall=fill(data.pipes.table[data.index_11, 11], integer(data.pipes.table[data.index_11, 1])),
    ths_insulation=fill(data.pipes.table[data.index_11, 12], integer(data.pipes.table[data.index_11, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_11, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-135,
        origin={88,-40})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _12(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_12, 11], integer(data.pipes.table[data.index_12, 1])),
    ths_insulation=fill(data.pipes.table[data.index_12, 12], integer(data.pipes.table[data.index_12, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_12, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={68,-60})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _18(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_18, 4],
        crossArea=data.pipes.table[data.index_18, 5],
        length=data.pipes.table[data.index_18, 2],
        angle=data.pipes.table[data.index_18, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_18, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_18, 7],
    p_b_start=data.pipes.table[data.index_18, 8],
    T_a_start=data.pipes.table[data.index_18, 9],
    T_b_start=data.pipes.table[data.index_18, 10],
    ths_wall=fill(data.pipes.table[data.index_18, 11], integer(data.pipes.table[data.index_18, 1])),
    ths_insulation=fill(data.pipes.table[data.index_18, 12], integer(data.pipes.table[data.index_18, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_18, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-135,
        origin={-62,-78})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _17(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_17, 4],
        crossArea=data.pipes.table[data.index_17, 5],
        length=data.pipes.table[data.index_17, 2],
        nV=integer(data.pipes.table[data.index_17, 1]),
        angle=data.pipes.table[data.index_17, 3]*Modelica.Constants.pi/180),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_17, 7],
    p_b_start=data.pipes.table[data.index_17, 8],
    T_a_start=data.pipes.table[data.index_17, 9],
    T_b_start=data.pipes.table[data.index_17, 10],
    ths_wall=fill(data.pipes.table[data.index_17, 11], integer(data.pipes.table[data.index_17, 1])),
    ths_insulation=fill(data.pipes.table[data.index_17, 12], integer(data.pipes.table[data.index_17, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_17, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,-50})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _16(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_16, 4],
        crossArea=data.pipes.table[data.index_16, 5],
        length=data.pipes.table[data.index_16, 2],
        angle=data.pipes.table[data.index_16, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_16, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_16, 7],
    p_b_start=data.pipes.table[data.index_16, 8],
    T_a_start=data.pipes.table[data.index_16, 9],
    T_b_start=data.pipes.table[data.index_16, 10],
    ths_wall=fill(data.pipes.table[data.index_16, 11], integer(data.pipes.table[data.index_16, 1])),
    ths_insulation=fill(data.pipes.table[data.index_16, 12], integer(data.pipes.table[data.index_16, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_16, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,-22})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _14a(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_14a, 4],
        crossArea=data.pipes.table[data.index_14a, 5],
        length=data.pipes.table[data.index_14a, 2],
        angle=data.pipes.table[data.index_14a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_14a, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_14a, 7],
    p_b_start=data.pipes.table[data.index_14a, 8],
    T_a_start=data.pipes.table[data.index_14a, 9],
    T_b_start=data.pipes.table[data.index_14a, 10],
    ths_wall=fill(data.pipes.table[data.index_14a, 11], integer(data.pipes.table[data.index_14a, 1])),
    ths_insulation=fill(data.pipes.table[data.index_14a, 12], integer(data.pipes.table[data.index_14a, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_14a, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-16,-10})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _15(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
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
    ths_wall=fill(data.pipes.table[data.index_15, 11], integer(data.pipes.table[data.index_15, 1])),
    ths_insulation=fill(data.pipes.table[data.index_15, 12], integer(data.pipes.table[data.index_15, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_15, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={-32,8})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _14(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_14, 4],
        crossArea=data.pipes.table[data.index_14, 5],
        length=data.pipes.table[data.index_14, 2],
        angle=data.pipes.table[data.index_14, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_14, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_14, 7],
    p_b_start=data.pipes.table[data.index_14, 8],
    T_a_start=data.pipes.table[data.index_14, 9],
    T_b_start=data.pipes.table[data.index_14, 10],
    ths_wall=fill(data.pipes.table[data.index_14, 11], integer(data.pipes.table[data.index_14, 1])),
    ths_insulation=fill(data.pipes.table[data.index_14, 12], integer(data.pipes.table[data.index_14, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_14, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-16,-40})));
  Fluid.Pipes.GenericPipe_withWallAndInsulation _13(
    m_flow_a_start=data.m_flow_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_13, 4],
        crossArea=data.pipes.table[data.index_13, 5],
        length=data.pipes.table[data.index_13, 2],
        angle=data.pipes.table[data.index_13, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_13, 1])),
    p_a_start(displayUnit="Pa") = data.pipes.table[data.index_13, 7],
    p_b_start=data.pipes.table[data.index_13, 8],
    T_a_start=data.pipes.table[data.index_13, 9],
    T_b_start=data.pipes.table[data.index_13, 10],
    ths_wall=fill(data.pipes.table[data.index_13, 11], integer(data.pipes.table[data.index_13, 1])),
    ths_insulation=fill(data.pipes.table[data.index_13, 12], integer(data.pipes.table[data.index_13, 1])),
    redeclare package Material_wall = Material_wall,
    redeclare package Material_insulation = Material_insulation,
    each Ts_ambient=fill(data.T_ambient, integer(data.pipes.table[data.index_13, 1])),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
                                                                                                           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-60})));
  Fluid.Volumes.ExpansionTank_1Port tank1(
    redeclare package Medium = Medium,
    p_start=data.p_primary,
    use_T_start=true,
    T_start=data.T_hot_primary,
    A=data.tank1_crossArea,
    level_start=0.5*data.tank1_length) annotation (Placement(transformation(extent={{-36,138},
            {-16,158}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium =                                                                           Medium, R=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-26,120})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium =                                                                      Medium, m_flow_nominal=data.m_flow_primary)
    annotation (Placement(transformation(extent={{36,-70},{16,-50}})));
  Fluid.Volumes.SimpleVolume volume(
    redeclare package Medium = Medium,
    p_start=_12.p_b_start,
    T_start=_12.T_b_start,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (                       V=0.01))
    annotation (Placement(transformation(extent={{36,-70},{56,-50}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_7a[integer(data.pipes.table[data.index_7a, 1])](surfaceArea=_7a.wall.geometry.crossAreas_1
        [end, :], each alpha=100000)
                                   annotation (Placement(transformation(extent={{118,114},
            {138,134}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary_7a(nPorts=integer(data.pipes.table[data.index_7a, 1]), T=fill(
        data.T_cold_primary, integer(data.pipes.table[data.index_7a, 1])))
                                                                   annotation (Placement(transformation(extent={{168,114},
            {148,134}})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_7b[integer(data.pipes.table[data.index_7b, 1])](surfaceArea=_7b.wall.geometry.crossAreas_1
        [end, :], each alpha=100000)
                                   annotation (Placement(transformation(extent={{118,86},
            {138,106}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary_7b(nPorts=integer(data.pipes.table[data.index_7b, 1]), T=fill(
        data.T_cold_primary, integer(data.pipes.table[data.index_7b, 1])))
                                                                   annotation (Placement(transformation(extent={{168,86},
            {148,106}})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder wall_1[integer(data.pipes.table[data.index_1, 1])](
    each exposeState_a=true,
    redeclare package Material = Material_wall,
    length=_1.geometry.dlengths,
    r_inner=0.5*_1.geometry.dimensions,
    r_outer=fill(data.pipes.table[data.index_1, 11], integer(data.pipes.table[data.index_1, 1])) + 0.5*_1.geometry.dimensions,
    Q_gen=fill(8000/integer(data.pipes.table[data.index_1, 1]), integer(data.pipes.table[data.index_1, 1])))
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-110,-50})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection_1[integer(data.pipes.table[data.index_1, 1])](surfaceArea=wall_1.surfaceArea_outer, each
      alpha=10)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-132,-50})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(use_port=false, nPorts=integer(data.pipes.table[data.index_1, 1]),
    T=fill(data.T_ctah, integer(data.pipes.table[data.index_1, 1])))
                          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-156,-50})));
  Fluid.Sensors.PressureTemperature sensor_pT(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_bar,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_degC)
                                       annotation (Placement(transformation(extent={{-126,
            -28},{-106,-8}})));
  Fluid.Sensors.PressureTemperature sensor_pT1(redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_bar,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_degC)
    annotation (Placement(transformation(extent={{-126,-72},{-106,-92}})));
  Fluid.Sensors.PressureTemperature sensor_pT2(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_bar,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_degC)
                                       annotation (Placement(transformation(extent={{98,142},
            {118,162}})));
  Fluid.Sensors.PressureTemperature sensor_pT3(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_bar,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_degC)
    annotation (Placement(transformation(extent={{94,80},{114,60}})));
equation
  connect(_1b.port_b, _1.port_a) annotation (Line(points={{-86,-64},{-86,-60}},   color={0,127,255}));
  connect(_1a.port_a, _1.port_b) annotation (Line(points={{-86,-36},{-86,-40}},
                                                                              color={0,127,255}));
  connect(_2.port_a, _1a.port_b) annotation (Line(points={{-86,-10},{-86,-16}}, color={0,127,255}));
  connect(_2a.port_a, _2.port_b) annotation (Line(points={{-86,16},{-86,10}},   color={0,127,255}));
  connect(_3.port_a, _2a.port_b) annotation (Line(points={{-86,40},{-86,36}},   color={0,127,255}));
  connect(_4.port_a, _3.port_b)
    annotation (Line(points={{-90.9289,70.9289},{-90.9289,65.465},{-86,65.465},
          {-86,60}},                                                                           color={0,127,255}));
  connect(_4.port_b, _5.port_a)
    annotation (Line(points={{-105.071,85.0711},{-112,85.0711},{-112,100},{-106,
          100}},                                                                       color={0,127,255}));
  connect(_5.port_b, _6.port_a) annotation (Line(points={{-86,100},{56.9289,100},
          {56.9289,108.929}},                                                                         color={0,127,255}));
  connect(_6.port_b, _6a.port_a) annotation (Line(points={{71.0711,123.071},{
          76.9289,128.929}},                                                                    color={0,127,255}));
  connect(_6a.port_b, _7a.port_a) annotation (Line(points={{91.0711,143.071},{
          108,143.071},{108,134}},                                                                   color={0,127,255}));
  connect(_7b.port_b, _8a.port_a) annotation (Line(points={{80,104},{76,104},{
          76,90}},                                                                      color={0,127,255}));
  connect(_8.port_b, _9.port_a) annotation (Line(points={{76,40},{76,33.0711},{
          80.9289,33.0711}},                                                                      color={0,127,255}));
  connect(_9.port_b, _10.port_a)
    annotation (Line(points={{95.0711,18.9289},{95.0711,11.4644},{104,11.4644},
          {104,0}},                                                                     color={0,127,255}));
  connect(_11.port_a, _10.port_b)
    annotation (Line(points={{95.0711,-32.9289},{95.0711,-26.4645},{104,
          -26.4645},{104,-20}},                                                         color={0,127,255}));
  connect(_7b.port_a, _7a.port_b) annotation (Line(points={{100,104},{108,104},
          {108,114}},                                                                   color={0,127,255}));
  connect(_8a.port_b, _8.port_a) annotation (Line(points={{76,70},{76,60}},   color={0,127,255}));
  connect(_12.port_a, _11.port_b) annotation (Line(points={{78,-60},{78,
          -47.0711},{80.9289,-47.0711}},                                                               color={0,127,255}));
  connect(_18.port_b, _1b.port_a)
    annotation (Line(points={{-69.0711,-85.0711},{-69.0711,-90},{-86,-90},{-86,
          -84}},                                                                        color={0,127,255}));
  connect(_17.port_b, _18.port_a) annotation (Line(points={{-46,-60},{-46,
          -70.9289},{-54.9289,-70.9289}},                                                                 color={0,127,255}));
  connect(_16.port_b, _17.port_a) annotation (Line(points={{-46,-32},{-46,-40}},
                                                                             color={0,127,255}));
  connect(_16.port_a, _15.port_b) annotation (Line(points={{-46,-12},{-46,
          0.92893},{-39.0711,0.92893}},                                                                color={0,127,255}));
  connect(_15.port_a, _14a.port_b) annotation (Line(points={{-24.9289,15.0711},
          {-16,15.0711},{-16,0}},                                                                       color={0,127,255}));
  connect(_14a.port_a, _14.port_b) annotation (Line(points={{-16,-20},{-16,-30}},
                                                                                color={0,127,255}));
  connect(_14.port_a, _13.port_b) annotation (Line(points={{-16,-50},{-16,-60},
          {-10,-60}},                                                                      color={0,127,255}));
  connect(resistance.port_b, tank1.port) annotation (Line(points={{-26,127},{
          -26,139.6}},                                                                    color={0,127,255}));
  connect(resistance.port_a, _6.port_a)
    annotation (Line(points={{-26,113},{-26,100},{56.9289,100},{56.9289,108.929}}, color={0,127,255}));
  connect(_13.port_a, pump_SimpleMassFlow.port_b) annotation (Line(points={{10,-60},
          {16,-60}},                                                                          color={0,127,255}));
  connect(pump_SimpleMassFlow.port_a, volume.port_a) annotation (Line(points={{36,-60},
          {40,-60}},                                                                              color={0,127,255}));
  connect(volume.port_b, _12.port_b) annotation (Line(points={{52,-60},{58,-60}}, color={0,127,255}));
  connect(_7a.heatPorts, convection_7a.port_a) annotation (Line(points={{113,124},
          {121,124}},                                                                        color={191,0,0}));
  connect(convection_7a.port_b, boundary_7a.port) annotation (Line(points={{135,124},
          {148,124}},                                                                            color={191,0,0}));
  connect(convection_7b.port_b, boundary_7b.port) annotation (Line(points={{135,96},
          {148,96}},                                                                             color={191,0,0}));
  connect(convection_7b.port_a, _7b.heatPorts) annotation (Line(points={{121,96},
          {90,96},{90,99}},                                                                           color={191,0,0}));
  connect(wall_1.port_a, _1.heatPorts[:, 1]) annotation (Line(points={{-100,-50},
          {-91,-50}},                                                                         color={191,0,0}));
  connect(convection_1.port_a, wall_1.port_b) annotation (Line(points={{-125,
          -50},{-120,-50}},                                                                    color={191,0,0}));
  connect(boundary.port, convection_1.port_b) annotation (Line(points={{-146,
          -50},{-139,-50}},                                                                    color={191,0,0}));
  connect(sensor_pT.port, _1a.port_a) annotation (Line(points={{-116,-28},{-116,
          -36},{-86,-36}},                                                                   color={0,127,255}));
  connect(sensor_pT1.port, _1b.port_b) annotation (Line(points={{-116,-72},{
          -116,-64},{-86,-64}},                                                         color={0,127,255}));
  connect(sensor_pT3.port, _8a.port_a)
    annotation (Line(points={{104,80},{104,90},{76,90}},  color={0,127,255}));
  connect(sensor_pT2.port, _7a.port_a)
    annotation (Line(points={{108,142},{108,134}},
                                                 color={0,127,255}));
  connect(_6a.port_b, sensor_pT2.port) annotation (Line(points={{91.0711,
          143.071},{108,143.071},{108,142}},
                                           color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{160,200}})),
    experiment(StopTime=10000, __Dymola_NumberOfIntervals=1000));
end CIET_initial;
