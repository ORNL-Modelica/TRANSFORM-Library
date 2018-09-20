within TRANSFORM.Examples.CIET_Facility.Examples;
model CIETLoop

  extends TRANSFORM.Icons.Example;

  package Medium = TRANSFORM.Media.Fluids.DOWTHERM.LinearDOWTHERM_A_95C;

  Fluid.Pipes.GenericPipe_MultiTransferSurface _1(
    T_a_start(displayUnit="K") = data.T_cold_primary,
    T_b_start(displayUnit="K") = data.T_hot_primary,
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1, 4],
        crossArea=data.pipes.table[data.index_1, 5],
        length=data.pipes.table[data.index_1, 2],
        angle=data.pipes.table[data.index_1, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1, 1])))
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,-10})));
  Data.Data_Basic data
    annotation (Placement(transformation(extent={{120,82},{140,102}})));
  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium,
    p=data.p_primary,
    nPorts=1)
    annotation (Placement(transformation(extent={{144,-52},{124,-32}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    redeclare package Medium = Medium,
    m_flow=data.m_flow_primary,
    T=data.T_cold_primary,
    nPorts=1)
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _1b(
    T_a_start(displayUnit="K") = data.T_cold_primary,
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1b, 4],
        crossArea=data.pipes.table[data.index_1b, 5],
        length=data.pipes.table[data.index_1b, 2],
        angle=data.pipes.table[data.index_1b, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1b, 1])),
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,-34})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _1a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_1a, 4],
        crossArea=data.pipes.table[data.index_1a, 5],
        length=data.pipes.table[data.index_1a, 2],
        angle=data.pipes.table[data.index_1a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_1a, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,14})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _2(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_2, 4],
        crossArea=data.pipes.table[data.index_2, 5],
        length=data.pipes.table[data.index_2, 2],
        angle=data.pipes.table[data.index_2, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_2, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,40})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _2a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_2a, 4],
        crossArea=data.pipes.table[data.index_2a, 5],
        length=data.pipes.table[data.index_2a, 2],
        angle=data.pipes.table[data.index_2a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_2a, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,66})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _4(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_4, 4],
        crossArea=data.pipes.table[data.index_4, 5],
        length=data.pipes.table[data.index_4, 2],
        angle=data.pipes.table[data.index_4, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_4, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-45,
        origin={-112,118})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _3(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_3, 4],
        crossArea=data.pipes.table[data.index_3, 5],
        length=data.pipes.table[data.index_3, 2],
        angle=data.pipes.table[data.index_3, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_3, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,90})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _5(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_5, 4],
        crossArea=data.pipes.table[data.index_5, 5],
        length=data.pipes.table[data.index_5, 2],
        angle=data.pipes.table[data.index_5, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_5, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,140})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _6(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_6, 4],
        crossArea=data.pipes.table[data.index_6, 5],
        length=data.pipes.table[data.index_6, 2],
        angle=data.pipes.table[data.index_6, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_6, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={50,156})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _6a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_6a, 4],
        crossArea=data.pipes.table[data.index_6a, 5],
        length=data.pipes.table[data.index_6a, 2],
        angle=data.pipes.table[data.index_6a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_6a, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={70,176})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _7a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_7a, 4],
        crossArea=data.pipes.table[data.index_7a, 5],
        length=data.pipes.table[data.index_7a, 2],
        angle=data.pipes.table[data.index_7a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_7a, 1])),
    T_a_start(displayUnit="K") = data.T_hot_primary,
    T_b_start(displayUnit="K") = 0.5*(data.T_hot_primary + data.T_cold_primary))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={94,164})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _7b(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_7b, 4],
        crossArea=data.pipes.table[data.index_7b, 5],
        length=data.pipes.table[data.index_7b, 2],
        angle=data.pipes.table[data.index_7b, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_7b, 1])),
    T_a_start(displayUnit="K") = 0.5*(data.T_hot_primary + data.T_cold_primary),
    T_b_start(displayUnit="K") = data.T_cold_primary) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={76,144})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface _8a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_8a, 4],
        crossArea=data.pipes.table[data.index_8a, 5],
        length=data.pipes.table[data.index_8a, 2],
        angle=data.pipes.table[data.index_8a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_8a, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={62,120})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _8(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_8, 4],
        crossArea=data.pipes.table[data.index_8, 5],
        length=data.pipes.table[data.index_8, 2],
        angle=data.pipes.table[data.index_8, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_8, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={62,90})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _9(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_9, 4],
        crossArea=data.pipes.table[data.index_9, 5],
        length=data.pipes.table[data.index_9, 2],
        angle=data.pipes.table[data.index_9, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_9, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45,
        origin={74,66})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _10(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_10, 4],
        crossArea=data.pipes.table[data.index_10, 5],
        length=data.pipes.table[data.index_10, 2],
        angle=data.pipes.table[data.index_10, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_10, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,30})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _11(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_11, 4],
        crossArea=data.pipes.table[data.index_11, 5],
        length=data.pipes.table[data.index_11, 2],
        angle=data.pipes.table[data.index_11, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_11, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-135,
        origin={74,0})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _12(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_12, 4],
        crossArea=data.pipes.table[data.index_12, 5],
        length=data.pipes.table[data.index_12, 2],
        angle=data.pipes.table[data.index_12, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_12, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-20})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _18(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_18, 4],
        crossArea=data.pipes.table[data.index_18, 5],
        length=data.pipes.table[data.index_18, 2],
        angle=data.pipes.table[data.index_18, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_18, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={-76,-38})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _17(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_17, 4],
        crossArea=data.pipes.table[data.index_17, 5],
        length=data.pipes.table[data.index_17, 2],
        nV=integer(data.pipes.table[data.index_17, 1]),
        angle=data.pipes.table[data.index_17, 3]*Modelica.Constants.pi/180),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-10})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _16(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_16, 4],
        crossArea=data.pipes.table[data.index_16, 5],
        length=data.pipes.table[data.index_16, 2],
        angle=data.pipes.table[data.index_16, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_16, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,18})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _14a(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_14a, 4],
        crossArea=data.pipes.table[data.index_14a, 5],
        length=data.pipes.table[data.index_14a, 2],
        angle=data.pipes.table[data.index_14a, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_14a, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,30})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _15(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_15, 4],
        crossArea=data.pipes.table[data.index_15, 5],
        length=data.pipes.table[data.index_15, 2],
        angle=data.pipes.table[data.index_15, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_15, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={-46,48})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _14(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_14, 4],
        crossArea=data.pipes.table[data.index_14, 5],
        length=data.pipes.table[data.index_14, 2],
        angle=data.pipes.table[data.index_14, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_14, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,0})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface _13(
    m_flow_a_start=data.m_flow_primary,
    p_a_start(displayUnit="Pa") = data.p_primary,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        roughness=data.roughness,
        dimension=data.pipes.table[data.index_13, 4],
        crossArea=data.pipes.table[data.index_13, 5],
        length=data.pipes.table[data.index_13, 2],
        angle=data.pipes.table[data.index_13, 3]*Modelica.Constants.pi/180,
        nV=integer(data.pipes.table[data.index_13, 1])),
    T_a_start=data.T_cold_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-10,-20})));
equation
  connect(_1b.port_b, _1.port_a)
    annotation (Line(points={{-100,-24},{-100,-20}}, color={0,127,255}));
  connect(_1a.port_a, _1.port_b)
    annotation (Line(points={{-100,4},{-100,0}}, color={0,127,255}));
  connect(_2.port_a, _1a.port_b)
    annotation (Line(points={{-100,30},{-100,24}}, color={0,127,255}));
  connect(_2a.port_a, _2.port_b)
    annotation (Line(points={{-100,56},{-100,50}}, color={0,127,255}));
  connect(_3.port_a, _2a.port_b)
    annotation (Line(points={{-100,80},{-100,76}}, color={0,127,255}));
  connect(_4.port_a, _3.port_b) annotation (Line(points={{-104.929,110.929},{
          -104.929,105.465},{-100,105.465},{-100,100}},
                                               color={0,127,255}));
  connect(_4.port_b, _5.port_a) annotation (Line(points={{-119.071,125.071},{
          -126,125.071},{-126,140},{-120,140}},
                                           color={0,127,255}));
  connect(_5.port_b, _6.port_a) annotation (Line(points={{-100,140},{42.9289,
          140},{42.9289,148.929}},
                              color={0,127,255}));
  connect(_6.port_b, _6a.port_a) annotation (Line(points={{57.0711,163.071},{
          62.9289,168.929}},
                     color={0,127,255}));
  connect(_6a.port_b, _7a.port_a) annotation (Line(points={{77.0711,183.071},{
          94,183.071},{94,174}},
                              color={0,127,255}));
  connect(_7b.port_b, _8a.port_a)
    annotation (Line(points={{66,144},{62,144},{62,130}}, color={0,127,255}));
  connect(_8.port_b, _9.port_a) annotation (Line(points={{62,80},{62,73.0711},{
          66.9289,73.0711}},
                     color={0,127,255}));
  connect(_9.port_b, _10.port_a) annotation (Line(points={{81.0711,58.9289},{
          81.0711,51.4644},{90,51.4644},{90,40}},
                                          color={0,127,255}));
  connect(_11.port_a, _10.port_b) annotation (Line(points={{81.0711,7.07107},{
          81.0711,13.5355},{90,13.5355},{90,20}},
                                          color={0,127,255}));
  connect(_7b.port_a, _7a.port_b)
    annotation (Line(points={{86,144},{94,144},{94,154}}, color={0,127,255}));
  connect(_8a.port_b, _8.port_a)
    annotation (Line(points={{62,110},{62,100}}, color={0,127,255}));
  connect(_12.port_a, _11.port_b) annotation (Line(points={{60,-20},{64,-20},{
          64,-7.07107},{66.9289,-7.07107}},
                                         color={0,127,255}));
  connect(boundary.ports[1], _12.port_b)
    annotation (Line(points={{124,-42},{40,-42},{40,-20}}, color={0,127,255}));
  connect(_18.port_b, _1b.port_a) annotation (Line(points={{-83.0711,-45.0711},
          {-83.0711,-50},{-100,-50},{-100,-44}},color={0,127,255}));
  connect(_17.port_b, _18.port_a) annotation (Line(points={{-60,-20},{-60,
          -30.9289},{-68.9289,-30.9289}},
                                color={0,127,255}));
  connect(_16.port_b, _17.port_a)
    annotation (Line(points={{-60,8},{-60,0}}, color={0,127,255}));
  connect(_16.port_a, _15.port_b) annotation (Line(points={{-60,28},{-60,
          40.9289},{-53.0711,40.9289}},
                               color={0,127,255}));
  connect(_15.port_a, _14a.port_b) annotation (Line(points={{-38.9289,55.0711},
          {-30,55.0711},{-30,40}},color={0,127,255}));
  connect(_14a.port_a, _14.port_b)
    annotation (Line(points={{-30,20},{-30,10}}, color={0,127,255}));
  connect(_14.port_a, _13.port_b) annotation (Line(points={{-30,-10},{-30,-20},{
          -20,-20}}, color={0,127,255}));
  connect(boundary1.ports[1], _13.port_a) annotation (Line(points={{-10,-60},{-4,
          -60},{-4,-56},{6,-56},{6,-20},{0,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{260,280}})),
    experiment(
      StopTime=2000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end CIETLoop;
