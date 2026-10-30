within TRANSFORM.Fluid.Valves;
model CheckValve
  extends TRANSFORM.Fluid.Valves.BaseClasses.PartialTwoPort(final allowFlowReversal=checkValve);
  input SIadd.HydraulicResistance R = Modelica.Constants.eps "Hydraulic resistance" annotation(Dialog(group="Inputs"));
  parameter Boolean checkValve=true "Reverse flow stopped";
  parameter SI.MassFlowRate m_flow_start = 0 "Mass flow rate" annotation(Dialog(tab="Initialization"));
  SI.MassFlowRate m_flow;
protected
  SI.Pressure dp;
  Real s(start=m_flow_start);
equation
  if checkValve then
    m_flow = homotopy(noEvent(if s > 0 then s else 0), s);
  else
    m_flow = s;
  end if;
  s*R = dp;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.m_flow = m_flow;
  port_a.p - port_b.p = dp;
  // Stream variables balance
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-94,40},{-18,0},{-94,-40},{-94,40}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=checkValve),
        Rectangle(
          extent={{-20,60},{20,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,50},{0,0}})}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CheckValve;
