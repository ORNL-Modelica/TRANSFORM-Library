within TRANSFORM.HeatExchangers.BellDelaware_STHX.Examples;
model STHX_BellDelaware_2Phase_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Fluid.Sources.MassFlowSource_T shell_inlet(
    m_flow=20/60^2*983,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T(displayUnit="degC") = 473.15)
              annotation (Placement(transformation(extent={{-46,54},{-34,66}})));
  Modelica.Fluid.Sources.Boundary_pT shell_outlet(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="bar") = 2000000,
    T(displayUnit="degC") = 413.15)
    annotation (Placement(transformation(extent={{-45,-65},{-35,-55}})));
  Modelica.Fluid.Sources.MassFlowSource_T tube_inlet(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T(displayUnit="degC") = 363.15,
    m_flow=1.5/60^2*983)
              annotation (Placement(transformation(extent={{46,-66},{34,-54}})));
  Modelica.Fluid.Sources.Boundary_pT tube_outlet(
    p(displayUnit="bar") = 100000,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T(displayUnit="degC") = 383.15)
              annotation (Placement(transformation(extent={{45,55},{35,65}})));
  inner Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_shell_inlet(redeclare package Medium =
                       Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{6.5,-5.5},{-6.5,5.5}},
        rotation=90,
        origin={-10.5,39.5})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_shell_outlet(
      redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(
        extent={{6,-5.5},{-6,5.5}},
        rotation=90,
        origin={-9.5,-40})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_tube_inlet(redeclare package Medium =
                       Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{-6,-5.5},{6,5.5}},
        rotation=90,
        origin={3.5,-40})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_tube_outlet(redeclare package Medium =
                       Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{-6.5,-5.5},{6.5,5.5}},
        rotation=90,
        origin={2.5,39.5})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_tOutlet
    annotation (Placement(transformation(extent={{20,34},{58,62}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_tInlet
    annotation (Placement(transformation(extent={{20,-42},{58,-12}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_sOutlet
    annotation (Placement(transformation(extent={{-60,-40},{-20,-14}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_sInlet
    annotation (Placement(transformation(extent={{-60,36},{-22,60}})));
  STHX_BellDelaware STHX(
    redeclare package Tube_Material =
        TRANSFORM.Media.Solids.AlloyN,
    n_tubes=66,
    DB=0.285,
    d_o=0.025,
    e1=0.0125,
    nes=8,
    D_i=0.310,
    n_MR=5,
    n_MRE=7.5,
    n_W_tubes=25,
    n_RW=2.5,
    nb=4,
    H=0.076,
    D_l=0.307,
    d_B=0.026,
    s1=0.032,
    s2=0.0277,
    S=0.184,
    d_N_a=0.2,
    d_N_b=0.2,
    p_a_start_shell=shell_outlet.p + 100,
    p_b_start_shell=shell_outlet.p,
    m_flow_start_shell=shell_inlet.m_flow,
    p_a_start_tube=tube_outlet.p + 100,
    p_b_start_tube=tube_outlet.p,
    th_tube=0.0015,
    nPasses=2,
    nParallel=1,
    redeclare package Medium_tube =
        Modelica.Media.Water.StandardWater,
    redeclare package Medium_shell =
        Modelica.Media.Water.StandardWater,
    T_a_start_tube=tube_inlet.T,
    T_b_start_tube=tube_outlet.T,
    m_flow_a_start_tube=tube_inlet.m_flow,
    T_a_start_shell=shell_inlet.T,
    T_b_start_shell=shell_outlet.T,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Alphas_TwoPhase_3Region)
    annotation (Placement(transformation(extent={{26,-20},{-20,20}})));
equation
  connect(shell_outlet.ports[1], sensor_shell_outlet.port_b) annotation (Line(
        points={{-35,-60},{-20,-60},{-9.5,-60},{-9.5,-46}}, color={0,127,255}));
  connect(tube_inlet.ports[1], sensor_tube_inlet.port_a) annotation (Line(
        points={{34,-60},{20,-60},{3.5,-60},{3.5,-46}}, color={0,127,255}));
  connect(tube_outlet.ports[1], sensor_tube_outlet.port_b)
    annotation (Line(points={{35,60},{2.5,60},{2.5,46}}, color={0,127,255}));
  connect(shell_inlet.ports[1], sensor_shell_inlet.port_a) annotation (Line(
        points={{-34,60},{-22,60},{-10.5,60},{-10.5,46}}, color={0,127,255}));
  connect(sensor_shell_inlet.statePort, stateDisplay_sInlet.statePort)
    annotation (Line(points={{-12.15,39.5},{-41,39.5},{-41,44.88}},
        color={0,0,0}));
  connect(sensor_tube_outlet.statePort, stateDisplay_tOutlet.statePort)
    annotation (Line(points={{0.85,39.5},{39,39.5},{39,44.36}},         color={
          0,0,0}));
  connect(sensor_tube_inlet.statePort, stateDisplay_tInlet.statePort)
    annotation (Line(points={{1.85,-40},{39,-40},{39,-30.9}},         color={0,
          0,0}));
  connect(sensor_shell_outlet.statePort, stateDisplay_sOutlet.statePort)
    annotation (Line(points={{-11.15,-40},{-40,-40},{-40,-30.38}},        color=
         {0,0,0}));
  connect(STHX.port_b_shell, sensor_shell_outlet.port_a) annotation (Line(
        points={{-9.65,-20},{-9.5,-20},{-9.5,-34}}, color={0,127,255}));
  connect(STHX.port_a_shell, sensor_shell_inlet.port_b) annotation (Line(points=
         {{-9.65,20},{-9.65,26},{-10.5,26},{-10.5,33}}, color={0,127,255}));
  connect(STHX.port_b_tube, sensor_tube_outlet.port_a) annotation (Line(points=
          {{3,20},{3,27},{2.5,27},{2.5,33}}, color={0,127,255}));
  connect(STHX.port_a_tube, sensor_tube_inlet.port_b)
    annotation (Line(points={{3,-20},{3.5,-20},{3.5,-34}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=500, __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end STHX_BellDelaware_2Phase_Test;
