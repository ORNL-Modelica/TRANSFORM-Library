within TRANSFORM.Fluid.Machines.Examples.SteamTurbineStodolaTests;
model SteamTurbineStodola_Test
  import TRANSFORM;
  extends Modelica.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph source(
    h=3.3e6,
    nPorts=1,
    use_p_in=true,
    p=15000000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=
       3000/60*3.14159)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph sink(
    h=2e6,
    nPorts=1,
    use_p_in=true,
    p=10000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{30,-30},{10,-50}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1,
    height=+79e5,
    offset=1e5,
    startTime=3)
    annotation (Placement(transformation(extent={{60,-58},{40,-38}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-70e5,
    duration=1,
    offset=150e5,
    startTime=1)
    annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  inner TRANSFORM.Fluid.System
                  system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.SteamTurbineStodola steamTurbine(
    eta_mech=0.98,
    m_flow_start=70,
    m_flow_nominal=70,
    Kt_constant=0.0025,
    h_a_start=3.3e6,
    h_b_start=2e6,
    use_T_start=false,
    use_NominalInlet=false,
    redeclare model Eta_wetSteam =
        TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
         eta_nominal=0.92),
    p_a_start=15000000,
    p_b_start=100000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={steamTurbine.Q_mech})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(steamTurbine.shaft_b, constantSpeed.flange)
    annotation (Line(points={{10,0},{20,0}},           color={0,0,0}));
  connect(source.ports[1],steamTurbine.portHP)  annotation (Line(points={{-30,20},
          {-20,20},{-20,6},{-10,6}},          color={0,127,255}));
  connect(steamTurbine.portLP, sink.ports[1]) annotation (Line(points={{7,-10},
          {7,-40},{10,-40}},       color={0,127,255}));
  connect(ramp.y, source.p_in)
    annotation (Line(points={{-59,28},{-56,28},{-52,28}}, color={0,0,127}));
  connect(ramp1.y, sink.p_in)
    annotation (Line(points={{39,-48},{39,-48},{32,-48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10));
end SteamTurbineStodola_Test;
