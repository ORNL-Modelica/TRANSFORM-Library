within TRANSFORM.Fluid.Machines.BaseClasses;
partial model PartialTurboPump
  extends PartialPump_Simple;

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (Placement(
        transformation(extent={{-10,50},{10,70}}, rotation=0),
        iconTransformation(extent={{-10,50},{10,70}})));

  parameter SI.AngularVelocity omega_nominal=1500 "Pump speed"
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

  SI.AngularVelocity omega(start=omega_nominal) "Shaft rotational speed";

  //SI.Temperature T_a = Medium.temperature(state_a);
  SI.Pressure p_a = port_a.p;
  SI.Density d_a = Medium.density_ph(port_a.p,inStream(port_a.h_outflow));  //Medium.density(state_a);
  //SI.Temperature T_b = Medium.temperature(state_b);
  SI.Pressure p_b = port_b.p;
  //SI.Density d_b = Medium.density(state_b);

  SI.VolumeFlowRate V_flow_a;
  //SI.VolumeFlowRate V_flow_b;
  SI.Height head;

  SI.Power Q_mech "Mechanical power added to system (i.e., pumping power)";
  SI.Angle phi "Shaft rotation angle";
  SI.Torque tau;

  SI.Acceleration g_n = Modelica.Constants.g_n;

equation


  m_flow = d_a*V_flow_a;
  //m_flow = d_b*V_flow_b;

  // Mechanical shaft power
  W = Q_mech;
  Q_mech = omega*tau;

  // Mechanical boundary conditions
  tau = shaft.tau;
  phi = shaft.phi;
  der(phi) = omega;

  dp = d_a*g_n*head;

end PartialTurboPump;
