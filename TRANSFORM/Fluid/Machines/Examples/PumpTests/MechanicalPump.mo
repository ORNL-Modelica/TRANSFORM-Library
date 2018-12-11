within TRANSFORM.Fluid.Machines.Examples.PumpTests;
model MechanicalPump
  extends TRANSFORM.Icons.Example;

  Pump_wShaft Pump(
    V=0.001,
    redeclare model FlowChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PerformanceCurve
        (V_flow_curve={0,0.001,0.0015}, head_curve={60,30,0}),
    use_powerCharacteristic=true,
    redeclare model PowerChar =
        ClosureRelations.PumpCharacteristics.Models.Power.PerformanceCurve (
          V_flow_curve={0,0.001,0.0015}, W_curve={350,500,600}),
    N_nominal=100,
    m_flow_nominal=1,
    d_nominal=1000,
    use_T_start=false,
    h_start=1e5,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    exposeState_a=false,
    exposeState_b=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dp_nominal=200000) annotation (Placement(transformation(extent={{-40,-10},
            {-20,10}}, rotation=0)));
  BoundaryConditions.Boundary_ph Source(
    p=101325,
    h=1e5,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    duration=5,
    height=1,
    startTime=15,
    offset=0.001) annotation (Placement(transformation(extent={{-20,40},{0,
            60}}, rotation=0)));
  BoundaryConditions.Boundary_ph Sink(
    p=80000,
    h=1e5,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{80,-10},{60,10}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp Ramp2(
    duration=5,
    startTime=2,
    height=100,
    offset=100) "380,0.01"
                 annotation (Placement(transformation(extent={{-80,-40},{-60,
            -20}}, rotation=0)));
  Mechanics.SimpleMotor                        SimpleMotor1(
    Rm=20,
    Lm=0.1,
    kT=35,
    Jm=10,
    dm=1) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}},
          rotation=0)));
  inner System             system
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  FittingsAndResistances.SpecifiedResistance ValveLin1(redeclare package Medium
      =        Modelica.Media.Water.StandardWater, R=1/(1e-5*Ramp1.y))
    annotation (Placement(transformation(extent={{20,-10},{40,10}},
          rotation=0)));
equation
  connect(Ramp2.y, SimpleMotor1.inPort)
    annotation (Line(points={{-59,-30},{-39.9,-30}}, color={0,0,127}));
  connect(ValveLin1.port_b, Sink.ports[1]) annotation (Line(
      points={{37,0},{48.5,0},{60,0}},
      color={0,127,255},
      thickness=0.5));
  connect(ValveLin1.port_a, Pump.port_b) annotation (Line(
      points={{23,0},{12,0},{2,0},{-20,0}},
      color={0,127,255},
      thickness=0.5));
  connect(Pump.port_a, Source.ports[1]) annotation (Line(
      points={{-40,0},{-46,0},{-50,0},{-60,0}},
      color={0,127,255},
      thickness=0.5));
  connect(SimpleMotor1.flange_b, Pump.shaft) annotation (Line(points=
          {{-20,-30},{-14,-30},{-14,14},{-30,14},{-30,8}}, color={0,0,
          0}));
  annotation (
    experiment(StopTime=25, Tolerance=1e-006),
    Documentation(info="<html>
<p>The model is designed to test the component <tt>PumpMech</tt>. The simple model of a DC motor <tt>Test.SimpleMotor</tt> is also used.<br>
The simulation starts with a stopped motor and a closed valve.
<ul>
    <li>t=2 s: The voltage supplied is increased up to 380V in 5 s.
    <li>t=15 s, The valve is opened in 5 s.
</ul>
<p>
Simulation Interval = [0...25] sec <br>
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6
</p>
</html>
",
 revisions=
         "<html>
<ul>
<li><i>5 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Updated.</li>
        <li><i>5 Feb 2004</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
        First release.</li>
</ul>
</html>"));
end MechanicalPump;
