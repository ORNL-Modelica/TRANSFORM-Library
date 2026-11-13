within TRANSFORM.UsersGuide.Conventions;
class ParameterWindow "Inputs, parameters and the parameter window"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<h4>Input or parameter</h4>
<p>A value the user sets is an <code>input</code> unless it has to be a <code>parameter</code>. An input can be given a number or an expression that changes during a run, with no extra connector and no switch. This is what lets one TRANSFORM component serve many scenarios.</p>
<p>A value is a parameter when:</p>
<ul>
<li>it sizes an array or adds or removes a component, a connector or an equation,</li>
<li>it is a start value or an initialization option, or</li>
<li>the model is known to be wrong if the value changes during a run.</li>
</ul>
<p>An input needs a <code>Dialog</code> annotation to show in the parameter window. It goes in a group named \"Inputs\":</p>
<pre>input SI.Volume V(min=0) \"Volume\" annotation (Dialog(group=\"Inputs\"));</pre>
<p>If an existing input is not meant to change during a run, the class's documentation says so under \"Assumptions and limits\".</p>
<h4>Tabs and groups</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Tab</th><th>Holds</th><th>Groups</th></tr>
<tr><td>General</td><td>Medium, replaceable models, the values most users set</td><td>\"Inputs\"; a group per replaceable model, such as \"Geometry\"</td></tr>
<tr><td>Initialization</td><td>Start values</td><td>\"Start Value: Absolute Pressure\", \"Start Value: Temperature\" and so on, one per quantity</td></tr>
<tr><td>Advanced</td><td>Dynamics options, optional ports, values few users change</td><td>\"Dynamics\"; \"Inputs\"; a group per topic, such as \"Heat Transfer\"</td></tr>
<tr><td>Visualization</td><td>Options that change only the icon or animation</td><td></td></tr>
<tr><td>Internal Interface</td><td>Values of a replaceable sub-model that the enclosing model sets, not the user</td><td>\"Inputs\"</td></tr>
</table>
<ul>
<li>Another tab is added only when a value fits none of these.</li>
<li>A new model with several sides, such as shell and tube, names its start-value tabs \"Initialization: \" followed by the side: \"Initialization: Shell\".</li>
<li>An input sits in a group named \"Inputs\". One exception: an input that belongs to a switch sits next to that switch in its topic group.</li>
</ul>
<h4>Start values</h4>
<ul>
<li>A start value is a parameter on the Initialization tab, in a group named \"Start Value: \" followed by the quantity.</li>
<li>Its default is an expression of other parameters or of the medium. It is never a number tuned from a simulation result.</li>
</ul>
<h4>Dynamics</h4>
<p>A component with balance equations offers the same options, in this form:</p>
<pre>import Modelica.Fluid.Types.Dynamics;

parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
  \"Formulation of energy balances\"
  annotation (Evaluate=true, Dialog(tab=\"Advanced\", group=\"Dynamics\"));
parameter Dynamics massDynamics=energyDynamics
  \"Formulation of mass balances\"
  annotation (Evaluate=true, Dialog(tab=\"Advanced\", group=\"Dynamics\"));
parameter Dynamics traceDynamics=massDynamics
  \"Formulation of trace substance balances\"
  annotation (Evaluate=true, Dialog(tab=\"Advanced\", group=\"Dynamics\"));</pre>
<h4>Optional port</h4>
<p>A port that can be switched on is a Boolean named <code>use_...</code>, a conditional connector, and a protected variable that the equations use whether or not the connector exists:</p>
<pre>parameter Boolean use_HeatPort=false \"= true to add a heat port\"
  annotation (Dialog(tab=\"Advanced\", group=\"Heat Transfer\"), Evaluate=true);
HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(
  T=medium.T, Q_flow=Q_flow_internal) if use_HeatPort
  \"Heat port at the fluid temperature\";
protected
  SI.HeatFlowRate Q_flow_internal;
equation
  if not use_HeatPort then
    Q_flow_internal = 0;
  end if;</pre>
<h4>Replaceable model</h4>
<p>A part of a component that the user chooses, such as its geometry or a correlation, is a replaceable model with a pick list, followed by one instance named after it:</p>
<pre>replaceable model Geometry =
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
  constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
  \"Geometry\" annotation (Dialog(group=\"Geometry\"), choicesAllMatching=true);

Geometry geometry \"Volume and height between the ports\";</pre>
<p>The chosen model has values of its own, which the user sets from the parameter window.</p>
</html>"));
end ParameterWindow;
