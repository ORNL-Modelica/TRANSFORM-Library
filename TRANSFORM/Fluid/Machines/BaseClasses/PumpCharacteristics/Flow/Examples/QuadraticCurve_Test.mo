within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.Examples;
model QuadraticCurve_Test
  import TRANSFORM;
  extends Icons.Example;

  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter SI.Pressure p = 5e5 "Pressure";
  parameter SI.Temperature T = 300 "Temperature";
  parameter Medium.ThermodynamicState state = Medium.setState_pT(p,T);

  parameter NonSI.AngularVelocity_rpm N_nominal = N.offset "Pump speed";
  parameter SI.Length diameter_nominal = diameter.offset "Impeller diameter";

  parameter SI.VolumeFlowRate V_flow_start=dp.offset;
  parameter SI.VolumeFlowRate V_flow_nominal=dp.offset;

  parameter SI.Height head_start = 1;
  parameter SI.Height head_nominal = 1;

  TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve
    quadraticCurve(
    redeclare package Medium = Medium,
    dp=dp.y,
    state=state,
    N=N.y,
    diameter=diameter.y,
    V_flow_start=V_flow_start,
    head_start=head_start,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    V_flow_nominal=V_flow_nominal,
    head_nominal=head_nominal)
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
  Modelica.Blocks.Sources.Trapezoid dp(
    rising=5,
    width=5,
    falling=5,
    period=60,
    startTime=10,
    amplitude=1e5,
    offset=1e5)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=90));
end QuadraticCurve_Test;
