within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power.Examples;
model Constant_Test
  import TRANSFORM;
  extends Icons.Example;
import NonSI = Modelica.SIunits.Conversions.NonSIunits;
  package Medium = Modelica.Media.Water.StandardWater;
  constant SI.Pressure p = 5e5 "Pressure";
  constant SI.Temperature T = 300 "Temperature";
  constant Medium.ThermodynamicState state = Medium.setState_pT(p,T) "Component state";
  parameter SI.Pressure p_a_start = p-1e5;
  parameter SI.Pressure p_b_start = p;
  parameter SI.SpecificEnthalpy h_start = Medium.specificEnthalpy(state);
  parameter SI.MassFlowRate m_flow_start = m_flow.offset;
  // Nominal conditions for Affinity Laws (Single pump basis)
  constant NonSI.AngularVelocity_rpm N_nominal = 1500 "Pump speed";
  constant SI.Length diameter_nominal = 0.1 "Impeller diameter";
  constant SI.MassFlowRate m_flow_nominal = 1 "Nominal mass flow rate";
  constant SI.Density rho_nominal = 1000 "Nominal density";
  constant SI.Pressure dp_nominal = 1e5 "Nominal pressure loss";
  TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power.Constant
    powerChar(
    redeclare package Medium = Medium,
    state=state,
    m_flow=m_flow.y,
    N=N.y,
    diameter=diameter.y,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    final rho_nominal=rho_nominal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final p_a_start=p_a_start,
    final p_b_start=p_b_start,
    final h_start=h_start,
    final m_flow_start=m_flow_start)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Trapezoid m_flow(
    rising=5,
    width=5,
    falling=5,
    period=60,
    startTime=10,
    amplitude=1,
    offset=0.5)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=90));
end Constant_Test;
