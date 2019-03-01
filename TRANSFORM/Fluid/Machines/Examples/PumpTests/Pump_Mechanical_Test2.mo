within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model Pump_Mechanical_Test2
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph Source(
    h=1.5e5,
    p=100000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1) annotation (Placement(transformation(extent={{-90,-10},{-70,
            10}}, rotation=0)));
  inner TRANSFORM.Fluid.System
                  system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.Pump_Mechanical pump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    N_nominal=1500,
    redeclare model FlowChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Flow.PerformanceCurve
        (head_curve={0,30,60}, V_flow_curve={0.0015,0.001,0}),
    p_a_start=100000,
    p_b_start=688484)
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={ValveLin.port_a.p})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Ramp Ramp2(
    duration=5,
    startTime=2,
    height=100,
    offset=100) "380,0.01"
                 annotation (Placement(transformation(extent={{-80,-40},{-60,
            -20}}, rotation=0)));
  TRANSFORM.Mechanics.SimpleMotor              SimpleMotor1(
    Rm=20,
    Lm=0.1,
    kT=35,
    Jm=10,
    dm=1) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    duration=5,
    height=1,
    startTime=15,
    offset=0.001) annotation (Placement(transformation(extent={{-20,40},{0,
            60}}, rotation=0)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance ValveLin(
      redeclare package Medium = Modelica.Media.Water.StandardWater, R=1/(1e-5*
        Ramp1.y)) annotation (Placement(transformation(extent={{20,-10},{40,10}},
          rotation=0)));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph
                                 Sink(
    p=80000,
    h=1e5,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{80,-10},{60,10}},
          rotation=0)));
equation
  connect(pump.port_a, Source.ports[1]) annotation (Line(
      points={{-44,0},{-58,0},{-58,0},{-70,0}},
      color={0,127,255},
      thickness=0.5));
  connect(Ramp2.y, SimpleMotor1.inPort) annotation (Line(points={{-59,-30},{-48,
          -30},{-48,-30},{-39.9,-30}}, color={0,0,127}));
  connect(SimpleMotor1.flange_b, pump.shaft) annotation (Line(points={{-20,-30},
          {-20,10},{-34,10},{-34,6}}, color={0,0,0}));
  connect(pump.port_b, ValveLin.port_a)
    annotation (Line(points={{-24,0},{23,0}}, color={0,127,255}));
  connect(ValveLin.port_b, Sink.ports[1])
    annotation (Line(points={{37,0},{60,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, Tolerance=1e-006));
end Pump_Mechanical_Test2;
