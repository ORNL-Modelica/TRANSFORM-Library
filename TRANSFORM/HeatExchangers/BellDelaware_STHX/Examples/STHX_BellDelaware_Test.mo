within TRANSFORM.HeatExchangers.BellDelaware_STHX.Examples;
model STHX_BellDelaware_Test
  extends Modelica.Icons.Example;

  Modelica.Fluid.Sources.MassFlowSource_T shell_inlet(
    m_flow=20/60^2*983,
    nPorts=1,
    T(displayUnit="degC") = 323.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
              annotation (Placement(transformation(extent={{-46,54},{-34,66}})));
  Modelica.Fluid.Sources.Boundary_pT shell_outlet(
    nPorts=1,
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 313.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-45,-65},{-35,-55}})));

  Modelica.Fluid.Sources.MassFlowSource_T tube_inlet(
    nPorts=1,
    m_flow=20/60^2*983,
    T(displayUnit="degC") = 293.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
              annotation (Placement(transformation(extent={{46,-66},{34,-54}})));
  Modelica.Fluid.Sources.Boundary_pT tube_outlet(
    p(displayUnit="bar") = 100000,
    nPorts=1,
    T(displayUnit="degC") = 303.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
              annotation (Placement(transformation(extent={{45,55},{35,65}})));

  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_shell_inlet(redeclare
      package Medium = Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{6.5,-5.5},{-6.5,5.5}},
        rotation=90,
        origin={-9.5,39.5})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_shell_outlet(
      redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(
        extent={{6,-5.5},{-6,5.5}},
        rotation=90,
        origin={-9.5,-44})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_tube_inlet(redeclare
      package Medium = Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{-6,-5.5},{6,5.5}},
        rotation=90,
        origin={2.5,-44})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateSensor sensor_tube_outlet(redeclare
      package Medium = Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{-6.5,-5.5},{6.5,5.5}},
        rotation=90,
        origin={2.5,39.5})));

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
    T_b_start_shell=shell_outlet.T)
    annotation (Placement(transformation(extent={{26,-18},{-20,22}})));

  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_sInlet
    annotation (Placement(transformation(extent={{-58,36},{-20,60}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_tOutlet
    annotation (Placement(transformation(extent={{20,34},{58,62}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_tInlet
    annotation (Placement(transformation(extent={{20,-44},{58,-14}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.stateDisplay stateDisplay_sOutlet
    annotation (Placement(transformation(extent={{-60,-42},{-20,-16}})));
equation
  connect(shell_inlet.ports[1], sensor_shell_inlet.port_a) annotation (Line(
        points={{-34,60},{-9.5,60},{-9.5,46}}, color={0,127,255}));
  connect(shell_outlet.ports[1], sensor_shell_outlet.port_b) annotation (Line(
        points={{-35,-60},{-9.5,-60},{-9.5,-50}}, color={0,127,255}));
  connect(tube_inlet.ports[1], sensor_tube_inlet.port_a) annotation (Line(
        points={{34,-60},{2.5,-60},{2.5,-50}}, color={0,127,255}));
  connect(STHX.port_b_shell, sensor_shell_outlet.port_a)
    annotation (Line(points={{-9.65,-18},{-9.5,-18},{-9.5,-38}}, color={0,127,
          255}));
  connect(STHX.port_a_tube, sensor_tube_inlet.port_b)
    annotation (Line(points={{3,-18},{2.5,-18},{2.5,-38}}, color={0,127,255}));
  connect(sensor_tube_outlet.port_a, STHX.port_b_tube) annotation (
     Line(points={{2.5,33},{2.5,33.5},{3,33.5},{3,22}}, color={0,127,255}));
  connect(sensor_shell_inlet.port_b, STHX.port_a_shell)
    annotation (Line(points={{-9.5,33},{-9.5,33.5},{-9.65,33.5},{-9.65,22}},
        color={0,127,255}));
  connect(sensor_tube_outlet.port_b, tube_outlet.ports[1]) annotation (Line(
        points={{2.5,46},{2,46},{2,60},{35,60}}, color={0,127,255}));
  connect(sensor_shell_inlet.statePort, stateDisplay_sInlet.statePort)
    annotation (Line(points={{-11.15,39.5},{-39,39.5},{-39,44.88}},
        color={0,0,0}));
  connect(sensor_tube_outlet.statePort, stateDisplay_tOutlet.statePort)
    annotation (Line(points={{0.85,39.5},{39,39.5},{39,44.36}},         color={
          0,0,0}));
  connect(sensor_tube_inlet.statePort, stateDisplay_tInlet.statePort)
    annotation (Line(points={{0.85,-44},{39,-44},{39,-32.9}},         color={0,
          0,0}));
  connect(sensor_shell_outlet.statePort, stateDisplay_sOutlet.statePort)
    annotation (Line(points={{-11.15,-44},{-40,-44},{-40,-32.38}},        color=
         {0,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=500, __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end STHX_BellDelaware_Test;
