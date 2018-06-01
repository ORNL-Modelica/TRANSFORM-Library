within TRANSFORM.Fluid.Pipes.Examples.RELAPComparison;
model HeatedPipe_Transients

  extends TRANSFORM.Icons.Example;

  import SI = Modelica.SIunits;
  import SIadd = TRANSFORM.Units;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter Integer iTest = 4 "Set test number to change test run";
  parameter String test_type[4] = {"lowQuality_10","highQuality_10","lowQuality_100","highQuality_100"};
  parameter SIadd.MassFlux Gs[4] = {10,10,100,100};
  parameter SI.HeatFlux Qs_pp[4] = {5e2,4e3,5e3,4e4};

  parameter SIadd.MassFlux G = Gs[iTest];
  parameter SI.HeatFlux Q_pp = Qs_pp[iTest];

  parameter Integer nV = 50;
  parameter Integer nR = 5;

  parameter SI.Length D_hyd = 0.015;
  parameter SI.Area area = 0.25*Modelica.Constants.pi*D_hyd^2;
  parameter SI.Length length = 20;
  parameter SI.Angle angle = Modelica.Constants.pi/2;

  parameter SI.Length roughness = 5e-5;
  parameter SI.Length r_outer = 7.5e-3;

  parameter SI.MassFlowRate m_flow_source = G*area;
  parameter SI.Temperature T_source = 450;
  parameter SI.Pressure p_sink = 5e6;
  parameter SI.SpecificEnthalpy h_sink = Medium.dewEnthalpy(Medium.setSat_p(p_sink));

  parameter SI.Area surfaceArea = Modelica.Constants.pi*D_hyd*length;
  parameter SI.Power Q_gen = Q_pp*surfaceArea/(nV*nR);

  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T source(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=m_flow_source,
    T(displayUnit="K") = T_source,
    use_m_flow_in=true)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph sink(
    nPorts=1,
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = p_sink,
    h=h_sink)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    exposeState_b=true,
    use_HeatTransfer=true,
    T_a_start=source.T,
    m_flow_a_start=source.m_flow,
    p_b_start=sink.p,
    redeclare package Medium = Medium,
    p_a_start=sink.p,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=D_hyd,
        length=length,
        roughness=roughness,
        angle=angle,
        nV=nV),
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_4Region
        (HT_width={0.02,0.005,0.0005}, HT_smooth={0,0.99,0.995}))
    "{sum(wall.geometry.crossAreas_1[end, :])/pipe.nV*wall.nParallel}"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));

  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(
      redeclare package Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D wall(
    T_a1_start=source.T,
    T_a2_start=source.T,
    exposeState_a1=true,
    exposeState_b1=true,
    exposeState_a2=true,
    exposeState_b2=true,
    adiabaticDims={false,true},
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_20_d_8000_cp_500,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        nR=nR,
        nZ=nV,
        r_outer=r_outer,
        length_z=length),
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gen=ramp.y))
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabatic(nPorts=wall.geometry.nR)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabatic1(nPorts=wall.geometry.nR)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,42})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabatic2(nPorts=wall.geometry.nZ) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    startTime=10,
    height=Q_gen)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Step step(
    height=m_flow_source*0.5,
    offset=m_flow_source,
    startTime=2000)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(resistance.port_a, pipe.port_b)
    annotation (Line(points={{-4.44089e-16,23},{-4.44089e-16,10},{0,10}},
                                                      color={0,127,255}));
  connect(pipe.port_a, source.ports[1])
    annotation (Line(points={{0,-10},{4.44089e-16,-10},{4.44089e-16,-40}},
                                                       color={0,127,255}));
  connect(adiabatic.port, wall.port_a2)
    annotation (Line(points={{-30,-20},{-30,-10}},        color={191,0,0}));
  connect(adiabatic2.port, wall.port_a1)
    annotation (Line(points={{-50,0},{-40,0},{-40,1.33227e-15}},
                                                    color={191,0,0}));
  connect(wall.port_b1, pipe.heatPorts[:, 1])
    annotation (Line(points={{-20,0},{-5,0}}, color={191,0,0}));
  connect(wall.port_b2, adiabatic1.port)
    annotation (Line(points={{-30,10},{-30,32}}, color={191,0,0}));
  connect(resistance.port_b, sink.ports[1])
    annotation (Line(points={{0,37},{0,60}}, color={0,127,255}));
  connect(step.y, source.m_flow_in)
    annotation (Line(points={{-19,-70},{-8,-70},{-8,-60}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"));
end HeatedPipe_Transients;
