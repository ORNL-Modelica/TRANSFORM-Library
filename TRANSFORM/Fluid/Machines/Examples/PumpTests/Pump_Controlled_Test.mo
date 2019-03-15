within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model Pump_Controlled_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph Source(
    h=1.5e5,
    p=100000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1) annotation (Placement(transformation(extent={{-90,-10},{-70,
            10}}, rotation=0)));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph SinkP(
    use_p_in=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    p=300000) annotation (Placement(transformation(extent={{50,-10},{30,10}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    duration=4,
    startTime=4,
    height=6e5,
    offset=1e5) annotation (Placement(transformation(extent={{100,0},{80,20}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp Step1(
    height=1,
    startTime=1,
    offset=1e-6,
    duration=1) annotation (Placement(transformation(extent={{-20,20},{0,40}},
          rotation=0)));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance ValveLin(R=1/(1e-5
        *Step1.y)) annotation (Placement(transformation(extent={{-6,-10},{14,10}},
          rotation=0)));
  inner TRANSFORM.Fluid.System
                  system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.Pump_Controlled pump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nParallel=2,
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Efficiency.Constant
        (eta_constant=0.7),
    N_nominal=1500,
    redeclare model FlowChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve
        (
        checkValve=true,
        head_curve={0,30,60},
        V_flow_curve={0.0015,0.001,0}),
    p_a_start=100000,
    p_b_start=688484)
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={ValveLin.port_a.p})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(Ramp1.y, SinkP.p_in)
    annotation (Line(points={{79,10},{66,10},{66,8},{52,8}}, color={0,0,127}));
  connect(pump.port_b, ValveLin.port_a)
    annotation (Line(points={{-24,0},{-14,0},{-14,0},{-3,0}},
                                              color={0,127,255}));
  connect(ValveLin.port_b, SinkP.ports[1]) annotation (Line(
      points={{11,0},{20,0},{30,0}},
      color={0,127,255},
      thickness=0.5));
  connect(pump.port_a, Source.ports[1]) annotation (Line(
      points={{-44,0},{-58,0},{-58,0},{-70,0}},
      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, Tolerance=1e-006));
end Pump_Controlled_Test;
