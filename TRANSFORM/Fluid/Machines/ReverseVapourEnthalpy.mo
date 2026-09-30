within TRANSFORM.Fluid.Machines;
model ReverseVapourEnthalpy
  "Zero-loss pass-through: forward flow keeps its enthalpy, reverse flow (toward port_a) carries saturated-vapour enthalpy"
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium"
    annotation (choicesAllMatching=true);

  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a(redeclare package Medium = Medium)
    "Machine side: reverse flow leaving here is saturated vapour"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    "Downstream side (typically a condenser or header)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  port_a.m_flow + port_b.m_flow = 0 "No storage";
  port_a.p = port_b.p "No pressure drop";
  port_b.h_outflow = inStream(port_a.h_outflow) "Forward: the upstream enthalpy passes through";
  port_a.h_outflow = Medium.dewEnthalpy(Medium.setSat_p(port_a.p))
    "Reverse: saturated vapour at the port pressure, whatever arrives from downstream";
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);

  annotation (defaultComponentName="reverseVapour",
    Icon(graphics={Rectangle(extent={{-80,40},{80,-40}}, lineColor={0,127,255},
          fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{-80,0}}, color={0,127,255}),
        Line(points={{80,0},{90,0}}, color={0,127,255}),
        Text(extent={{-76,30},{76,-30}}, textString="h_v <-", lineColor={0,127,255}),
        Text(extent={{-150,90},{150,50}}, textString="%name", lineColor={0,0,255})}),
    Documentation(info="<html>
<p>A two-port element with no storage and no pressure drop that treats the two flow
directions differently:</p>
<ul>
<li><b>Forward</b> (port_a &rarr; port_b): the enthalpy arriving at port_a passes through
unchanged. In forward flow the element is transparent.</li>
<li><b>Reverse</b> (port_b &rarr; port_a): the fluid leaving port_a carries the
<em>saturated-vapour</em> enthalpy at the port pressure, whatever enthalpy arrives at
port_b.</li>
</ul>

<h4>When to use it</h4>
<p>Place it between a steam machine's exhaust (port_a) and a lumped two-phase volume that
the machine discharges into (port_b), when that volume can push flow back up the exhaust.
A lumped two-phase volume usually hands any outflow the enthalpy of its <em>bulk
mixture</em>. In a condenser or a heater shell that bulk is mostly liquid, so a small
reverse flow (for example the slosh in a steam path left with no through-flow after its
supply is isolated) carries liquid enthalpy up into the machine and the volumes behind
it. What a real exhaust draws back from such a vessel is its steam space, which this
element represents.</p>
<p>Prefer fixing the vessel's own outflow rule when that is possible (for example
<code>TRANSFORM.Fluid.Volumes.Condenser.steamSpaceOutflow</code>). This element exists for
the case where the vessel's port is shared by other sources and changing its rule is
undesirable: it applies the vapour rule to one connection only.</p>

<h4>Limitations</h4>
<ul>
<li><b>Not energy-conserving in reverse flow.</b> The downstream side books the enthalpy it
actually sends while the upstream side receives the saturated-vapour enthalpy; the
difference, reverse mass flow times the enthalpy gap, is created or destroyed here. It is
intended for small, short-lived reverse flows; check its size against the energy stored
in the connected volumes before relying on it for sustained reverse flow.</li>
<li>Requires a two-phase medium (<code>setSat_p</code>, <code>dewEnthalpy</code>). Above the
critical pressure the saturation functions are undefined.</li>
<li>Substance (<code>Xi</code>) and trace (<code>C</code>) streams pass straight through in
both directions.</li>
</ul>
<p>Used optionally at the exhaust of
<a href=\"modelica://TRANSFORM.Fluid.Machines.MultiStageTurbine\">MultiStageTurbine</a>
(parameter <code>use_vapourBackflow_b</code>).</p>
</html>"));
end ReverseVapourEnthalpy;
