within TRANSFORM.Fluid.Machines;
model Pump_SinglePhase
  extends BaseClasses.PartialPump_SinglePhase(final allowFlowReversal=not
        checkValve);

  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  parameter Boolean checkValve=false "=true then no reverse flow";

  input SI.Length diameter=diameter_nominal "Impeller diameter"
    annotation (Dialog(group="Inputs"));

  replaceable model FlowChar =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Flow.TableBasedInterpolation_old
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Flow.PartialFlowChar
    "Head vs. Volumetric flow rate" annotation (Dialog(group="Characteristics: Based on single pump nominal conditions"),
      choicesAllMatching=true);
  FlowChar flowChar(
    redeclare final package Medium = Medium,
    final dp=dp,
    final state=state_a,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    final V_flow_start=V_flow_start,
    final head_start=head_start,
    final V_flow_nominal=V_flow_nominal,
    final head_nominal=head_nominal,
    final checkValve=checkValve)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Length diameter_nominal=0.1524 "Impeller diameter"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.PressureDifference dp_nominal=p_b_start - p_a_start
    "Pressure increase"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.MassFlowRate m_flow_nominal=m_flow_start "Mass flow rate"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Density d_nominal=d_start "Density"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));

  final parameter SI.VolumeFlowRate V_flow_nominal=m_flow_nominal/d_nominal;
  final parameter SI.Height head_nominal=dp_nominal/(d_nominal*Modelica.Constants.g_n);

  final parameter SI.Density d_start=Medium.density_phX(
      p_a_start,
      h_a_start,
      X_start) "Density";

  final parameter SI.VolumeFlowRate V_flow_start=m_flow_start/d_start;
  final parameter SI.Height head_start=(p_b_start - p_a_start)/Modelica.Constants.g_n
      /d_start;

  NonSI.AngularVelocity_rpm N(start=N_nominal) = omega*60/(2*Modelica.Constants.pi)
    "Shaft rotational speed";

  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;
  SI.Density d_inlet=Medium.density(state_a);

  SI.VolumeFlowRate V_flow=m_flow/d_inlet;
  SI.Height head=flowChar.head;

equation

  V_flow = flowChar.V_flow;

  eta_is = 0.7;

  annotation (
    defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Pump_SinglePhase;
