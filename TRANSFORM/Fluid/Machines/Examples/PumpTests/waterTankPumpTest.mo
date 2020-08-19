within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model waterTankPumpTest
  "Test the different regions of the homologous pump by pumping between tanks"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;
  package Medium = Modelica.Media.Water.StandardWater;
  TurboPump                          circulator(
    redeclare package Medium = Medium,
    p_a_start(displayUnit="bar") = 1000000,
    p_b_start(displayUnit="bar") = 1100000,
    T_a_start=303.15,
    m_flow_start=1,
    omega_nominal(displayUnit="rpm") = 2199.1148575129,
    m_flow_nominal=50,
    eta_nominal=1)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}})));
  Volumes.ExpansionTank_1Port tank(
    redeclare package Medium = Medium,
    A=1,
    V0=100,
    p_surface=1000000,
    level_start=0,
    use_T_start=true,
    T_start=303.15)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Volumes.ExpansionTank_1Port tank1(
    redeclare package Medium = Medium,
    A=1,
    V0=100,
    p_surface=1000000,
    level_start=0,
    use_T_start=true,
    T_start=303.15,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=1,  w(start=
          circulator.omega_nominal)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-40})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-0.9*circulator.tau_nominal,
    duration=800,
    offset=circulator.tau_nominal,
    startTime=100)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(circulator.port_a, tank1.port)
    annotation (Line(points={{10,0},{70,0},{70,1.6}}, color={0,127,255}));
  connect(circulator.port_b, tank.port)
    annotation (Line(points={{-10,0},{-70,0},{-70,1.6}},  color={0,127,255}));
  connect(circulator.shaft, inertia.flange_b) annotation (Line(points={{0,-6},{0,
          -10},{5.55112e-16,-10}}, color={0,0,0}));
  connect(inertia.flange_a, torque.flange) annotation (Line(points={{-5.55112e-16,
          -30},{5.55112e-16,-30}}, color={0,0,0}));
  connect(ramp.y, torque.tau)
    annotation (Line(points={{-39,-70},{0,-70},{0,-52}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=2000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end waterTankPumpTest;
