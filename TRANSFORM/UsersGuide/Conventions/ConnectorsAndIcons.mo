within TRANSFORM.UsersGuide.Conventions;
class ConnectorsAndIcons "What the look of a port means"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>The look of a port says what the component defines there. A user can then see which ports should be joined.</p>
<ul>
<li>A filled port: the component defines the flow through the port (mass flow rate, heat flow rate). It uses a connector class ending in <code>_Flow</code>, such as <code>FluidPort_Flow</code> or <code>HeatPort_Flow</code>.</li>
<li>A white port with a colored outline: the component defines the state at the port (pressure, temperature). It uses a connector class ending in <code>_State</code>, such as <code>FluidPort_State</code> or <code>HeatPort_State</code>.</li>
<li>The usual connection joins a filled port to a white port.</li>
</ul>
<h4>A port that a parameter can switch</h4>
<p>Some components let a parameter decide whether a port defines the state, for example <code>exposeState_a</code>. A connector's own look cannot follow a parameter, so in most such components the port keeps its filled connector class and the component's icon draws a white oval behind the port. The oval's <code>visible</code> attribute is the switch, so it shows only while the port defines the state.</p>
<h4>Other icon rules</h4>
<ul>
<li>A component meant to be dragged into a diagram sets <code>defaultComponentName</code>.</li>
<li>An example extends <code>TRANSFORM.Icons.Example</code>.</li>
</ul>
</html>"));
end ConnectorsAndIcons;
