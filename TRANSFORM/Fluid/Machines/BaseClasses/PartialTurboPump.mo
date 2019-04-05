within TRANSFORM.Fluid.Machines.BaseClasses;
partial model PartialTurboPump
  extends PartialPump_Simple;
extends TRANSFORM.Icons.UnderConstruction;
import NonSI = Modelica.SIunits.Conversions.NonSIunits;
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (Placement(
        transformation(extent={{-10,50},{10,70}}, rotation=0),
        iconTransformation(extent={{-10,50},{10,70}})));

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

  SI.VolumeFlowRate V_flow;
  SI.Height head;


  SI.Power Q_mech "Mechanical power added to system (i.e., pumping power)";
  SI.Angle phi "Shaft rotation angle";
  SI.Torque tau;
  SI.AngularVelocity omega=N*2*Modelica.Constants.pi/60
    "Shaft angular velocity";

  SI.Acceleration g_n = Modelica.Constants.g_n;

  Medium.ThermodynamicState state_b;
equation
  state_b = Medium.setState_phX(port_b.p,
    inStream(port_b.h_outflow),
    inStream(port_b.Xi_outflow));

  V_flow=m_flow/d_inlet;

  // Mechanical shaft power
  W = Q_mech;
  Q_mech = omega*tau;

  // Mechanical boundary conditions
  tau = shaft.tau;
  shaft.phi = phi;
  der(phi) = omega;

  port_b.p/Medium.density(state_b) - port_a.p/d_inlet = g_n*head;

end PartialTurboPump;
