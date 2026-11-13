within TRANSFORM.UsersGuide.Conventions;
class Naming "Names of classes, instances and variables"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<h4>Classes</h4>
<ul>
<li>A class name starts with an upper-case letter and is written in CamelCase: <code>SimpleVolume</code>, <code>ExpansionTank</code>.</li>
<li>A function name starts with a lower-case letter: <code>spliceTanh</code>.</li>
<li>An underscore joins a variant to its base name: <code>GenericPipe_MultiTransferSurface</code>, <code>ExpansionTank_1Port</code>.</li>
<li>A partial class is named <code>Partial...</code> and sits in a package named <code>BaseClasses</code>.</li>
<li>Examples sit in a package named <code>Examples</code>. Their names are covered on the Examples page.</li>
</ul>
<h4>Instances and variables</h4>
<ul>
<li>An instance or variable name starts with a lower-case letter: <code>geometry</code>, <code>heatPort</code>, <code>massDynamics</code>.</li>
<li>A symbol from physics keeps its usual case: <code>T</code>, <code>V</code>, <code>Re</code>, <code>Q_flow</code>.</li>
<li>Where a class has one instance of a replaceable model, the instance takes the model's name in lower case: <code>Geometry geometry</code>.</li>
</ul>
<h4>Words</h4>
<ul>
<li>A name spells its words out: <code>crossArea</code>, <code>nParallel</code>, <code>length_heated</code>. The length of a name is not a concern.</li>
<li>A short form is used only when it is the usual one in the field: a symbol from physics (<code>T</code>, <code>p</code>, <code>Re</code>, <code>cp</code>, <code>dp</code>), a suffix from the table below, or <code>n</code> for a size.</li>
<li>A name is not shortened to letters a reader has to decode: not <code>nPar</code>, <code>Tw</code> or <code>geo</code>.</li>
</ul>
<h4>Suffixes</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Suffix</th><th>Meaning</th><th>Example</th></tr>
<tr><td><code>_flow</code></td><td>Flow rate of the quantity</td><td><code>m_flow</code>, <code>Q_flow</code></td></tr>
<tr><td><code>_start</code></td><td>Start value</td><td><code>p_start</code></td></tr>
<tr><td><code>_nominal</code></td><td>Nominal value</td><td><code>m_flow_nominal</code></td></tr>
<tr><td><code>_a</code>, <code>_b</code></td><td>The two ports or ends of a component</td><td><code>port_a</code>, <code>T_b_start</code></td></tr>
<tr><td><code>_internal</code></td><td>Protected variable that stands in for an optional connector</td><td><code>Q_flow_internal</code></td></tr>
</table>
<p>When several are combined the order is quantity, port, role, side: <code>p_a_start_shell</code> is the start pressure at port a on the shell side.</p>
<h4>Arrays and sizes</h4>
<ul>
<li>An array of a quantity takes a plural <code>s</code> on the quantity: <code>Ts_start</code>, <code>m_flows</code>, <code>crossAreas</code>.</li>
<li>A size is <code>n</code> followed by what is counted: <code>nV</code>, <code>nSurfaces</code>.</li>
</ul>
<h4>Switches</h4>
<ul>
<li>A new Boolean parameter that adds or removes a port or a feature is named <code>use_</code> followed by what it adds: <code>use_HeatPort</code>, <code>use_TraceMassPort</code>.</li>
<li>Existing switches with another prefix (<code>show...</code>, <code>exposeState_...</code>, <code>allow...</code>) keep their names.</li>
</ul>
<h4>Existing names</h4>
<p>A public name that does not follow this page stays as it is, including a misspelled one. It changes only as an announced change with a conversion rule, as CONTRIBUTING.md describes.</p>
</html>"));
end Naming;
