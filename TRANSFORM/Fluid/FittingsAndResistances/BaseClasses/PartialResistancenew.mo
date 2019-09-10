within TRANSFORM.Fluid.FittingsAndResistances.BaseClasses;
partial model PartialResistancenew
  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean showName=true "= false to hide component name"
    annotation (Dialog(tab="Visualization"));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
  parameter SI.MassFlowRate m_flow_start=0 "Initial mass flow rate"
    annotation (Dialog(tab="Initialization"));
  parameter SI.MassFlowRate m_flow_smooth=0.001
    "Smoothing tolerance around zero flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter SI.MassFlowRate dp_smooth=0.001
    "Smoothing tolerance around zero flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
    "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
    "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));
  Medium.ThermodynamicState state_a;
  Medium.ThermodynamicState state_b;
  Medium.ThermodynamicState state;
  SI.PressureDifference dp;
  SI.MassFlowRate m_flow(start=m_flow_start);
protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";
equation
  port_a.m_flow + port_b.m_flow = 0;
  dp = port_a.p - port_b.p;
  m_flow = port_a.m_flow;
  state_a = Medium.setState_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));
  state_b = Medium.setState_phX(
    port_b.p,
    inStream(port_b.h_outflow),
    inStream(port_b.Xi_outflow));
  state = Medium.setSmoothState(
    dp,
    state_a,
    state_b,
    dp_smooth);
  // Stream variables balance
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
          Bitmap(extent={{-100,60},{-60,100}},
                                             fileName="modelica://TRANSFORM/Resources/Images/Icons/Resistance_Fluid.jpg")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialResistancenew;
