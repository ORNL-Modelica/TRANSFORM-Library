within TRANSFORM.Fluid.Pipes;
model GenericPipe_withWallAndInsulation
  import Modelica.Fluid.Types.Dynamics;
  outer TRANSFORM.Fluid.SystemTF systemTF;
input SI.Length ths_wall[pipe.geometry.nV] annotation(Dialog(group="Inputs"));
input SI.Length ths_insulation[pipe.geometry.nV] annotation(Dialog(group="Inputs"));
input SI.Temperature Ts_ambient[pipe.geometry.nV]=fill(293.15,pipe.geometry.nV) "Ambient temperature" annotation(Dialog(group="Inputs"));
input SI.CoefficientOfHeatTransfer alphas_ambient[pipe.geometry.nV] = fill(10,pipe.geometry.nV) annotation(Dialog(group="Inputs"));
  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
                                                                                      "Geometry"
    annotation (Dialog(group="Geometry"),choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));
  extends BaseClasses.GenericPipe_Record_multiSurface(
    final nV=pipe.geometry.nV,
    use_HeatTransfer=true);
  replaceable package Material_wall =
      TRANSFORM.Media.Solids.SS316                     constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Wall material properties" annotation (choicesAllMatching=true);
  replaceable package Material_insulation =
      TRANSFORM.Media.Solids.FiberGlassGeneric                    constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Wall material properties" annotation (choicesAllMatching=true);
  // Initialization: Wall
  parameter Dynamics energyDynamics_wall=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization: Wall", group="Dynamics"));
  parameter Dynamics energyDynamics_insulation=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization: Wall", group="Dynamics"));
  parameter SI.Temperature T_wall_start=Medium.T_default
    "Wall temperature" annotation (Dialog(tab="Initialization: Wall",
        group="Start Value: Temperature"));
  parameter SI.Temperature T_insulation_start=T_wall_start "Insulation temperature"
    annotation (Dialog(tab="Initialization: Wall", group="Start Value: Temperature"));
  GenericPipe_MultiTransferSurface
              pipe(
    nParallel=nParallel,
    redeclare package Medium = Medium,
    redeclare model FlowModel = FlowModel,
    use_HeatTransfer=use_HeatTransfer,
    redeclare model HeatTransfer = HeatTransfer,
    redeclare model InternalHeatGen = InternalHeatGen,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    traceDynamics=traceDynamics,
    ps_start=ps_start,
    use_Ts_start=use_Ts_start,
    Ts_start=Ts_start,
    hs_start=hs_start,
    Xs_start=Xs_start,
    Cs_start=Cs_start,
    p_a_start=p_a_start,
    p_b_start=p_b_start,
    T_a_start=T_a_start,
    T_b_start=T_b_start,
    h_a_start=h_a_start,
    h_b_start=h_b_start,
    X_a_start=X_a_start,
    X_b_start=X_b_start,
    C_a_start=C_a_start,
    C_b_start=C_b_start,
    m_flow_a_start=m_flow_a_start,
    m_flow_b_start=m_flow_b_start,
    m_flows_start=m_flows_start,
    momentumDynamics=momentumDynamics,
    exposeState_a=exposeState_a,
    exposeState_b=exposeState_b,
    g_n=g_n,
    useInnerPortProperties=useInnerPortProperties,
    useLumpedPressure=useLumpedPressure,
    lumpPressureAt=lumpPressureAt,
    redeclare model Geometry = Geometry)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean showDesignFlowDirection = true annotation(Dialog(tab="Visualization"));
  extends TRANSFORM.Utilities.Visualizers.IconColorMap(showColors=systemTF.showColors, val_min=systemTF.val_min,val_max=systemTF.val_max, val=pipe.summary.T_effective);
  parameter Boolean use_heatPort_addWall = false "=true for additional source/sink for heat between wall and insulation" annotation(Dialog(group="Heat Transfer"));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder wall[pipe.geometry.nV](
    length=pipe.geometry.dlengths,
    r_inner={pipe.geometry.surfaceAreas[1, i]/(pipe.geometry.dlengths[i]*2*
        Modelica.Constants.pi) for i in 1:pipe.geometry.nV},
    redeclare package Material = Material_wall,
    each energyDynamics=energyDynamics_wall,
    each T_start=T_wall_start,
    r_outer=ths_wall + wall.r_inner,
    each exposeState_a=true,
    Q_gen=Q_gen)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
  HeatAndMassTransfer.Volumes.SimpleWall_Cylinder insulation[pipe.geometry.nV](
    length=pipe.geometry.dlengths,
    r_inner=wall.r_outer,
    each exposeState_a=true,
    redeclare package Material = Material_insulation,
    each energyDynamics=energyDynamics_insulation,
    each T_start=T_insulation_start,
    r_outer=ths_insulation + wall.r_outer)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  HeatAndMassTransfer.Resistances.Heat.Convection convection[pipe.geometry.nV](alpha=
        alphas_ambient, surfaceArea=insulation.surfaceArea_outer)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,10})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(nPorts=
        pipe.geometry.nV, use_port=true)
                          annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,32})));
  Modelica.Blocks.Sources.RealExpression boundaryT[pipe.geometry.nV](y=
        Ts_ambient) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,60})));
  HeatAndMassTransfer.Interfaces.HeatPort_Flow heatPorts_add[geometry.nV,
    geometry.nSurfaces - 1] if geometry.nSurfaces > 1
    annotation (Placement(transformation(extent={{20,-80},{40,-60}}),
        iconTransformation(extent={{20,-10},{40,10}})));
  HeatAndMassTransfer.Interfaces.HeatPort_Flow heatPorts_addWall[geometry.nV] if use_heatPort_addWall "Additional heat source/sink between wall and insulation" annotation (Placement(
        transformation(extent={{20,-46},{40,-26}}), iconTransformation(extent={{
            20,22},{40,42}})));
  input SI.HeatFlowRate Q_gen[geometry.nV]=zeros(geometry.nV) "Wall internal heat generation" annotation(Dialog(group="Inputs"));
equation
  connect(port_a, pipe.port_a) annotation (Line(
      points={{-100,0},{-60,0},{-60,-80},{-10,-80}},
      color={0,127,255},
      thickness=0.5));
  connect(port_b, pipe.port_b) annotation (Line(
      points={{100,0},{100,0},{60,0},{60,-80},{10,-80}},
      color={0,127,255},
      thickness=0.5));
  connect(wall.port_a, pipe.heatPorts[:, 1])
    annotation (Line(points={{0,-60},{0,-75}}, color={191,0,0}));
  connect(boundary.port, convection.port_a)
    annotation (Line(points={{0,22},{0,17}}, color={191,0,0}));
  connect(boundaryT.y, boundary.T_ext)
    annotation (Line(points={{0,49},{0,36}}, color={0,0,127}));
  connect(wall.port_b, insulation.port_a)
    annotation (Line(points={{0,-40},{0,-30}}, color={191,0,0}));
  connect(insulation.port_b, convection.port_b) annotation (Line(points={{4.44089e-16,
          -10},{0,-10},{0,3}}, color={191,0,0}));
  connect(heatPorts_add, pipe.heatPorts[:,2:geometry.nSurfaces])
    annotation (Line(points={{30,-70},{0,-70},{0,-75}}, color={191,0,0}));
  connect(heatPorts_addWall, wall.port_b)
    annotation (Line(points={{30,-36},{0,-36},{0,-40}}, color={191,0,0}));
  annotation (defaultComponentName="pipe",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b),
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,127,255}, if showColors then dynColor else {0,127,255})),
        Ellipse(
          extent={{-65,5},{-55,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{55,5},{65,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,40},{90,32}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-90,-32},{90,-40}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Polygon(
          points={{20,-50},{50,-60},{20,-70},{20,-50}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Rectangle(
          extent={{-90,-24},{90,-32}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-90,32},{90,24}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-30,40},{-30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{30,40},{30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericPipe_withWallAndInsulation;
