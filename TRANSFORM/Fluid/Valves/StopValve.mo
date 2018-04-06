within TRANSFORM.Fluid.Valves;
model StopValve

  extends TRANSFORM.Fluid.Valves.BaseClasses.PartialTwoPort(final allowFlowReversal=checkValve);

  parameter Boolean stopValve=true "Flow stopped";

equation

  if checkValve then
    port_a.m_flow = 0;
    port_b.m_flow = 0;
  else
    port_a.p = port_b.p;
    port_a.m_flow + port_b.m_flow = 0;
  end if;

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
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-20,60},{20,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,50},{0,0}})}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StopValve;
