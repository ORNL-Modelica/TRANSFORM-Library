within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Efficiency.Examples;
model Constant_Test
  import TRANSFORM;
  extends Icons.Example;

  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter SI.Pressure p = 5e5 "Pressure";
  parameter SI.Temperature T = 300 "Temperature";
  parameter Medium.ThermodynamicState state = Medium.setState_pT(p,T);

  parameter NonSI.AngularVelocity_rpm N_nominal = N.offset "Pump speed";
  parameter SI.Length diameter_nominal = diameter.offset "Impeller diameter";


  parameter SI.VolumeFlowRate V_flow_start=V_flow.offset;
  parameter SI.VolumeFlowRate V_flow_nominal=V_flow.offset;


  TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Efficiency.Constant
    efficiencyChar(
    redeclare package Medium = Medium,
    V_flow=V_flow.y,
    state=state,
    N = N.y,
    diameter = diameter.y,
    V_flow_start=V_flow_start,
    N_nominal=N_nominal,
    diameter_nominal=diameter_nominal,
    V_flow_nominal=V_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Trapezoid N(
    amplitude=1500,
    rising=5,
    width=5,
    falling=5,
    period=40,
    offset=500,
    startTime=30)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.Trapezoid diameter(
    amplitude=0.1,
    rising=5,
    width=5,
    falling=5,
    period=20,
    offset=0.05,
    startTime=50)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Sources.Trapezoid V_flow(
    rising=5,
    width=5,
    falling=5,
    period=60,
    startTime=10,
    amplitude=1,
    offset=0.5)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=90));
end Constant_Test;
