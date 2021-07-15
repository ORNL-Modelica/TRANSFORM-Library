within TRANSFORM.Fluid.Valves.BaseClasses;
partial model PartialTwoPortTransport
  "Partial element transporting fluid between two ports without storage of mass or energy"
  extends TRANSFORM.Fluid.Valves.BaseClasses.PartialTwoPort;
  // Advanced
  // Note: value of dp_start shall be refined by derived model, basing on local dp_nominal
  parameter Medium.AbsolutePressure dp_start(min=-Modelica.Constants.inf) = 1e-5
      "Guess value of dp = port_a.p - port_b.p"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium.MassFlowRate m_flow_start = 0
      "Guess value of m_flow = port_a.m_flow"
    annotation(Dialog(tab = "Advanced"));
  // Note: value of m_flow_small shall be refined by derived model, basing on local m_flow_nominal
  parameter Medium.MassFlowRate m_flow_small = 1e-2
      "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  // Diagnostics
  parameter Boolean show_T = true
      "= true, if temperatures at port_a and port_b are computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean show_V_flow = true
      "= true, if volume flow rate at inflowing port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  // Variables
  Medium.MassFlowRate m_flow(
     min=if allowFlowReversal then -Modelica.Constants.inf else 0,
     start = m_flow_start) "Mass flow rate in design flow direction";
  Modelica.Units.SI.Pressure dp(start=dp_start)
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  Modelica.Units.SI.VolumeFlowRate V_flow=m_flow/
      Modelica.Fluid.Utilities.regStep(
              m_flow,
              Medium.density(state_a),
              Medium.density(state_b),
              m_flow_small) if     show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";
  Medium.Temperature port_a_T=
      Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                  Medium.temperature(state_a),
                  Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                  m_flow_small) if show_T
      "Temperature close to port_a, if show_T = true";
  Medium.Temperature port_b_T=
      Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                  Medium.temperature(state_b),
                  Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                  m_flow_small) if show_T
      "Temperature close to port_b, if show_T = true";
protected
  Medium.ThermodynamicState state_a "state for medium inflowing through port_a";
  Medium.ThermodynamicState state_b "state for medium inflowing through port_b";
equation
  // medium states
  state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
  state_b = Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow));
  // Pressure drop in design flow direction
  dp = port_a.p - port_b.p;
  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  assert(m_flow > -m_flow_small or allowFlowReversal, "Reverting flow occurs even though allowFlowReversal is false");
  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;
  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without storing mass or energy.
Energy may be exchanged with the environment though, e.g., in the form of work.
<code>PartialTwoPortTransport</code> is intended as base class for devices like orifices, valves and simple fluid machines.</p>
<p>
Three equations need to be added by an extending class using this component:
</p>
<ul>
<li>the momentum balance specifying the relationship between the pressure drop <code>dp</code> and the mass flow rate <code>m_flow</code>,</li>
<li><code>port_b.h_outflow</code> for flow in design direction, and</li>
<li><code>port_a.h_outflow</code> for flow in reverse direction.</li>
</ul>
<p>
Moreover appropriate values shall be assigned to the following parameters:
</p>
<ul>
<li><code>dp_start</code> for a guess of the pressure drop</li>
<li><code>m_flow_small</code> for regularization of zero flow.</li>
</ul>
</html>"));
end PartialTwoPortTransport;
