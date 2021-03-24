within TRANSFORM.Fluid.Machines.BaseClasses;
partial model PartialPump_nom
  extends PartialPump_Simple(final allowFlowReversal=not
        flowChar.checkValve);

  import         Modelica.Units.NonSI;

  input SI.Length diameter=diameter_nominal "Impeller diameter"
    annotation (Dialog(group="Inputs"));

  replaceable model FlowChar =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PartialFlowChar
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
    final head_nominal=head_nominal)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));
  parameter Boolean use_powerCharacteristic=false
    "=true then use power characteristic else efficiency" annotation (Evaluate=
        true, Dialog(group=
          "Characteristics: Based on single pump nominal conditions"));
  replaceable model PowerChar =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Power.Constant
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Power.PartialPowerChar
    "Power consumption vs. Volumetric flow rate" annotation (Dialog(group=
          "Characteristics: Based on single pump nominal conditions", enable=
          use_powerCharacteristic), choicesAllMatching=true);
  PowerChar powerChar(
    redeclare final package Medium = Medium,
    final state=state_a,
    final V_flow_start=V_flow_start,
    final V_flow=V_flow,
    final V_flow_nominal=V_flow_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    final d_nominal = d_nominal,
    final W_nominal=W_nominal)
    annotation (Placement(transformation(extent={{-56,84},{-44,96}})));

  replaceable model EfficiencyChar =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Efficiency.Constant
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Efficiency.PartialEfficiencyChar
    "Efficiency vs. Volumetric flow rate" annotation (Dialog(group=
          "Characteristics: Based on single pump nominal conditions", enable=
          not use_powerCharacteristic), choicesAllMatching=true);
  EfficiencyChar efficiencyChar(
    redeclare final package Medium = Medium,
    final state=state_a,
    final V_flow_start=V_flow_start,
    final V_flow=V_flow,
    final V_flow_nominal=V_flow_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal)
    annotation (Placement(transformation(extent={{-76,84},{-64,96}})));

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Length diameter_nominal=0.1524 "Impeller diameter"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.PressureDifference dp_nominal=p_b_start - p_a_start
    "Pressure increase"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.MassFlowRate m_flow_nominal=m_flow_start/nParallel "Mass flow rate"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Density d_nominal=d_start "Density"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));

  final parameter SI.VolumeFlowRate V_flow_nominal=m_flow_nominal/d_nominal;
  final parameter SI.Height head_nominal=dp_nominal/(d_nominal*Modelica.Constants.g_n);

  final parameter SI.Density d_start=Medium.density_phX(
      p_a_start,
      h_a_start,
      X_start) "Density";
  final parameter SI.Power W_nominal = V_flow_nominal*dp_nominal;

  final parameter SI.VolumeFlowRate V_flow_start=m_flow_start/d_start;
  final parameter SI.Height head_start=(p_b_start - p_a_start)/Modelica.Constants.g_n
      /d_start;

  NonSI.AngularVelocity_rpm N(start=N_nominal) "Shaft rotational speed";

  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;
  SI.Density d_inlet=Medium.density(state_a);

  SI.VolumeFlowRate V_flow=flowChar.V_flow;
  SI.Height head(start=head_start)=flowChar.head;

equation

  if use_powerCharacteristic then
    W = powerChar.W;
  else
    eta_is = efficiencyChar.eta;
  end if;

  V_flow=m_flow/d_inlet;

end PartialPump_nom;
