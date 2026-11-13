within TRANSFORM.UsersGuide.Conventions;
class Descriptions "Description strings"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>The description string is the first comment on anything. Every tool keeps it, and it is what a user sees in the package browser, the parameter window and the list of results.</p>
<h4>What has one</h4>
<ul>
<li>Every class.</li>
<li>Every parameter and every input.</li>
<li>Every public variable.</li>
<li>Every component in a library model.</li>
<li>In a new or edited example, every component. There the description says the component's role in the scenario, not its type: <code>\"Saturated liquid from the condenser\"</code>. The standard helper blocks, <code>unitTests</code> and the system component, need one only when there is something to say about them in that example.</li>
</ul>
<h4>Form</h4>
<ul>
<li>It is written in sentence case: a capital first letter, then capitals only for names and symbols. A description that starts with <code>#</code> or <code>=</code> has no letter to capitalize. It has no final period.</li>
<li>It carries no unit. The type carries the unit.</li>
<li>It fits on one line of the parameter window: about 60 characters. What needs more room goes in the documentation.</li>
<li>A description may be split over source lines with <code>+</code>, but the parameter window still shows it as one line. A description that needs a second source line needs a reason.</li>
</ul>
<h4>Content</h4>
<ul>
<li>It says what the thing is in this model. It does not repeat the type, the default value or the expression it is bound to.</li>
<li>It is the shortest phrase that keeps the meaning. Drop articles and \"of the\": <code>\"Heated section length\"</code>, not <code>\"Length of the heated section\"</code>.</li>
<li>Shorter stops where meaning is lost. Keep every word that tells this thing apart from its neighbours, and do not shorten a word to letters a reader has to decode.</li>
<li>A count is written <code>\"# of ...\"</code>: <code>\"# of parallel components\"</code>.</li>
<li>A Boolean reads <code>\"= true to ...\"</code>: <code>\"= true to add a heat port\"</code>. A switch between two alternatives names both: <code>\"= true to start from T_start, false from h_start\"</code>.</li>
<li>A connector's description says what it carries or where it sits on the component: <code>\"Heat port at the fluid temperature\"</code>.</li>
<li>A class that a user picks from a list, such as a correlation or a geometry, may use the bar form: name, variant and form separated by bars, as in <code>\"Dittus Boelter | Simple | A*Re^B*Pr^C\"</code>. The bars let a user compare neighbouring classes at a glance.</li>
</ul>
<h4>Instead of, write</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Instead of</th><th>Write</th></tr>
<tr><td><code>\"volume [m3].\"</code></td><td><code>\"Volume\"</code></td></tr>
<tr><td><code>\"The number of parallel components\"</code></td><td><code>\"# of parallel components\"</code></td></tr>
<tr><td><code>\"Heat port flag\"</code></td><td><code>\"= true to add a heat port\"</code></td></tr>
<tr><td><code>\"Length of the section of the pipe that is heated\"</code></td><td><code>\"Heated section length\"</code></td></tr>
<tr><td><code>\"HTC, tube side\"</code></td><td><code>\"Tube side heat transfer coefficient\"</code></td></tr>
<tr><td><code>\"Boundary_ph\"</code> (in an example)</td><td><code>\"Saturated liquid from the condenser\"</code></td></tr>
</table>
</html>"));
end Descriptions;
