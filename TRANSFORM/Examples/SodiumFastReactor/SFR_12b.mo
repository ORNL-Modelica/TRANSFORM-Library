within TRANSFORM.Examples.SodiumFastReactor;
model SFR_12b

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

  Components.DRACS_ADHX dRACS_ADHX[3](redeclare package Medium =
        Medium_DRACS)
    annotation (Placement(transformation(extent={{-156,-52},{-216,8}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    nPorts=3,
    p=100000,
    T=data.T_IHX_inletPHTS,
    redeclare package Medium = Medium_PHTS)
              annotation (Placement(transformation(extent={{-82,-90},{-102,-70}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower(
    m_flow=data.m_flow_DRACS,
    T=data.T_IHX_inletPHTS,
    redeclare package Medium = Medium_PHTS,
    nPorts=1) annotation (Placement(transformation(extent={{-68,-10},{-88,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower1(
    m_flow=data.m_flow_DRACS,
    T=data.T_IHX_inletPHTS,
    redeclare package Medium = Medium_PHTS,
    nPorts=1) annotation (Placement(transformation(extent={{-52,6},{-72,26}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
              Medium =
               Medium_PHTS, R=1/data.m_flow_DRACS)
    annotation (Placement(transformation(extent={{-100,30},{-120,50}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance1(redeclare
      package Medium = Medium_PHTS, R=1/data.m_flow_DRACS)
    annotation (Placement(transformation(extent={{-84,46},{-104,66}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance2(redeclare
      package Medium = Medium_PHTS, R=1/data.m_flow_DRACS)
    annotation (Placement(transformation(extent={{-116,52},{-136,72}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower2(
    m_flow=data.m_flow_DRACS,
    T=data.T_IHX_inletPHTS,
    redeclare package Medium = Medium_PHTS,
    nPorts=1) annotation (Placement(transformation(extent={{-36,22},{-56,42}})));
equation

  connect(dRACS_ADHX.port_b, IHX1.port_b_tube) annotation (Line(points={{-156,-10},
          {-124,-10},{-124,-20}}, color={0,127,255}));
  connect(IHX1.port_a_tube, dRACS_ADHX.port_a) annotation (Line(points={{-124,-40},
          {-124,-50},{-140,-50},{-140,-40},{-156,-40}}, color={0,127,255}));
  connect(atmosphere.ports[1:3], IHX1.port_b_shell) annotation (Line(points={{-102,
          -82.6667},{-110,-82.6667},{-110,-78},{-119.4,-78},{-119.4,-40}},
        color={0,127,255}));
  connect(resistance.port_b, IHX1[1].port_a_shell) annotation (Line(points={{
          -117,40},{-119.4,40},{-119.4,-20}}, color={0,127,255}));
  connect(resistance1.port_b, IHX1[2].port_a_shell) annotation (Line(points={{
          -101,56},{-101,19},{-119.4,19},{-119.4,-20}}, color={0,127,255}));
  connect(resistance2.port_b, IHX1[3].port_a_shell) annotation (Line(points={{
          -133,62},{-126,62},{-126,-20},{-119.4,-20}}, color={0,127,255}));
  connect(blower.ports[1], resistance.port_a) annotation (Line(points={{-88,0},
          {-96,0},{-96,40},{-103,40}}, color={0,127,255}));
  connect(blower1.ports[1], resistance1.port_a) annotation (Line(points={{-72,
          16},{-78,16},{-78,56},{-87,56}}, color={0,127,255}));
  connect(blower2.ports[1], resistance2.port_a) annotation (Line(points={{-56,
          32},{-88,32},{-88,62},{-119,62}}, color={0,127,255}));
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
end SFR_12b;
