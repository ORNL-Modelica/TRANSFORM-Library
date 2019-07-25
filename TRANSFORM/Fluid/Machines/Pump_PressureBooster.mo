within TRANSFORM.Fluid.Machines;
model Pump_PressureBooster
  "Prescribes mass flow rate across the component"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium model"
    annotation(choicesAllMatching = true);
  parameter Boolean use_input=false "Use connector input for outlet pressure" annotation(choices(checkBox=true));
  parameter SI.Pressure p_nominal=1e5 "Nominal outlet pressure (port_b.p)";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction" annotation(Dialog(tab="Advanced"));
  SI.Pressure p "Outlet pressure (port_b.p)";
  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium, m_flow(
        min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_State port_b(
                                   redeclare package Medium = Medium, m_flow(
        max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput in_p(value=p_internal) if
                                                use_input annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={0,73})));
protected
  SI.Pressure p_internal;
equation
  if not use_input then
    p_internal =p_nominal;
  end if;
  p = p_internal;
  port_a.m_flow + port_b.m_flow = 0;
  port_b.p = p;
  // Balance Equations
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-80,30},{-40,-30}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-2,60},{80,0}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-20,20},{-20,-22},{30,0},{-20,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
                   Text(extent={{-22,18},{28,-14}},
          lineColor={0,0,0},
          textString="p")}),
    Documentation(info="<HTML>
This component prescribes the flow rate passing through it. The change of
specific enthalpy due to the pressure difference between the inlet and the
outlet is ignored; use <t>Pump</t> models if this has to be taken into account correctly.
<p><b>Modelling options</b></p>
<p>If <tt>w0Fix</tt> is set to true, the flowrate is given by the parameter <tt>w0</tt>; otherwise, the <tt>in_w0</tt> connector must be wired, providing the (possibly varying) flowrate value.</p>
</HTML>",
        revisions="<html>
<ul>
<li><i>18 Mar 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
end Pump_PressureBooster;
