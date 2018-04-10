within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Examples;
model TestFlow1D2phChen "Test case for Flow1D2phChen"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.WaterIF97_ph;
  import Modelica.Constants.*;
  // number of Nodes
  parameter Integer Nnodes=8;
  // total length
  parameter SI.Length Lpipe=20;
  // internal diameter
  parameter SI.Diameter Dpipe=0.01;
  // wall thickness
  parameter SI.Thickness thpipe=0.002;
  // internal radius
  parameter SI.Radius rpipe=Dpipe/2;
  // internal perimeter
  parameter SI.Length omegapipe=pi*Dpipe;
  // internal cross section
  parameter SI.Area Apipe=pi*rpipe^2;
  // friction factor
  parameter Real Cfpipe=0.005;

  ThermoPower.Water.ValveLin valve(Kv=0.05/60e5, redeclare package
      Medium =
        Modelica.Media.Water.StandardWater)      annotation (Placement(
        transformation(extent={{30,-70},{50,-50}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp extTemp1(
    duration=100,
    height=60,
    offset=540,
    startTime=100) annotation (Placement(transformation(extent={{-100,20},{
            -80,40}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp extTemp2(
    duration=100,
    height=-30,
    startTime=500) annotation (Placement(transformation(extent={{-100,60},{
            -80,80}}, rotation=0)));
  Modelica.Blocks.Math.Add Add1 annotation (Placement(transformation(extent=
           {{-66,40},{-46,60}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1,
    duration=1)                                           annotation (
      Placement(transformation(extent={{10,-40},{30,-20}}, rotation=0)));
  Modelica.Blocks.Math.Add Add2 annotation (Placement(transformation(extent=
           {{0,70},{20,90}}, rotation=0)));
  Modelica.Blocks.Sources.Constant DT(k=5) annotation (Placement(
        transformation(extent={{-36,60},{-16,80}}, rotation=0)));

  inner System_TP system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature[Nnodes] annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=-90,
        origin={-10,-13})));
  dfa dfa1(nNodes=Nnodes) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,18})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection[Nnodes]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-38})));
  Modelica.Blocks.Sources.Constant const[Nnodes](each k=pipe.diameter*
        Modelica.Constants.pi*pipe.length/Nnodes*10000)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  ThermoPower.Water.SourceMassFlow
                            Source(
    w0=0.05,
    G=0.05/600e5,
    use_in_h=true,
    p0=6000000)   annotation (Placement(transformation(extent={{-62,-70},{-42,
            -50}}, rotation=0)));
  Modelica.Blocks.Sources.Step hIn(
    height=0,
    offset=1e6,
    startTime=30) annotation (Placement(transformation(extent={{-100,-50},{
            -80,-30}},
                   rotation=0)));
  ThermoPower.Water.SinkPressure
                          Sink(p0=10000)
                                     annotation (Placement(transformation(
          extent={{70,-70},{90,-50}}, rotation=0)));
equation

  connect(xValve.y, valve.cmd) annotation (Line(points={{31,-30},{40,-30},{
          40,-52}}, color={0,0,127}));
  connect(DT.y, Add2.u2) annotation (Line(points={{-15,70},{-8,70},{-8,74},
          {-2,74}}, color={0,0,127}));
  connect(Add2.u1, Add1.y) annotation (Line(points={{-2,86},{-40,86},{-40,50},{
          -45,50}},      color={0,0,127}));
  connect(extTemp1.y, Add1.u2)
    annotation (Line(points={{-79,30},{-68,44}}, color={0,0,127}));
  connect(extTemp2.y, Add1.u1)
    annotation (Line(points={{-79,70},{-68,56}}, color={0,0,127}));
  connect(Add2.y, dfa1.temperature_nodeN) annotation (Line(points={{21,80},{30,80},
          {30,36},{-13,36},{-13,30}},     color={0,0,127}));
  connect(dfa1.temperature_node1, Add1.y)
    annotation (Line(points={{-7,30},{-7,50},{-45,50}}, color={0,0,127}));
  connect(dfa1.y, prescribedTemperature.T)
    annotation (Line(points={{-10,6},{-10,-1}},             color={0,0,127}));
  connect(pipe.heatPorts, convection.solid) annotation (Line(points={{-9.9,-55.6},
          {-9.9,-52.8},{-10,-52.8},{-10,-48}}, color={127,0,0}));
  connect(convection.fluid, prescribedTemperature.port)
    annotation (Line(points={{-10,-28},{-10,-23}},           color={191,0,0}));
  connect(const.y, convection.Gc) annotation (Line(points={{-39,-20},{-30,-20},{
          -30,-38},{-20,-38}}, color={0,0,127}));
  connect(hIn.y, Source.in_h) annotation (Line(points={{-79,-40},{-48,-40},{
          -48,-54}}, color={0,0,127}));
  connect(Source.flange, pipe.port_a) annotation (Line(points={{-42,-60},{-32,
          -60},{-20,-60}}, color={0,0,255}));
  connect(valve.outlet, Sink.flange)
    annotation (Line(points={{50,-60},{60,-60},{70,-60}}, color={0,0,255}));
  connect(pipe.port_b, valve.inlet)
    annotation (Line(points={{0,-60},{30,-60}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})),
    experiment(StopTime=1000, Tolerance=1e-008),
    Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2phDB</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow, computation of the heat transfer coefficient).<br>
This model represent the fluid side of a once-through boiler with an applied external linear temperature profile. The operating fluid is water.<br>
The simulation proceeds through the following steps:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid. After 40 seconds all the thermal transients have settled.
    <li>t=100 s. Ramp increase of the external temperature profile. The water starts boiling at t=118 s. At the end of the transient (t=300) the outlet fluid is superheated vapour.</li>
    <li>t=500 s. Ramp decrease of the external temperature profile. After the transient has settled, the fluid in the boiler is again subcooled water.</li>
</ul>
<p> During the transient it is possible to observe the change in the heat transfer coefficients when boiling takes place; note that the h.t.c.'s  do not change abruptly due to the smoothing algorithm inside the <tt>Flow1D2phDB</tt> model.
<p>
Simulation Interval = [0...1000] sec <br>
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-8
</p>
</HTML>",
      revisions="<html>
<ul>
    <li><i>4 Feb 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    First release.</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput(equdistant=false));
end TestFlow1D2phChen;
