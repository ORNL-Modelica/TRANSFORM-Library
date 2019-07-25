within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase_Mechanical
  extends TRANSFORM.Fluid.Machines.BaseClasses.PartialTurbine(final eta_is=1.0,
      eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  replaceable model FlowChar =
      TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Flow.HyperbolicTangent
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Flow.PartialFlowChar
    "Flow characteristics" annotation (Dialog(group="Characteristics: Based on single turbine nominal conditions"),
      choicesAllMatching=true);
  FlowChar flowChar(
    redeclare final package Medium = Medium,
    final PR=PR,
    final state=state_a,
    final N=N,
    final N_nominal=N_nominal,
    final m_flow_nominal=m_flow_nominal,
    final T_nominal = T_nominal,
    final p_nominal = p_a_start,
    final PR_nominal = PR_nominal)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Speed"
    annotation (Dialog(group="Nominal Conditions: Single turbine basis"));
    parameter SI.Temperature T_nominal = Medium.temperature(Medium.setState_phX(p_a_start,h_a_start,X_start));

  parameter SIadd.NonDim PR_nominal=p_b_start/p_a_start
    "Pressure ratio (p_b/p_a)"
    annotation (Dialog(group="Nominal Conditions: Single turbine basis"));
  parameter SI.MassFlowRate m_flow_nominal=m_flow_start "Mass flow rate"
    annotation (Dialog(group="Nominal Conditions: Single turbine basis"));
//   parameter SI.Density d_nominal=Medium.density(Medium.setState_phX(p_a_start,h_a_start,X_start)) "Density"
//     annotation (Dialog(group="Nominal Conditions: Single turbine basis"));

  NonSI.AngularVelocity_rpm N "Shaft rotational speed";
  Real PR "port_b.p/port_a.p pressure ratio";
  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;
  SI.Density d_inlet=Medium.density(state_a);

equation
  omega = N*2*Modelica.Constants.pi/60;
  m_flow = flowChar.m_flow;
  PR = port_b.p/port_a.p;

  annotation(defaultComponentName="turbine");
end Turbine_SinglePhase_Mechanical;
