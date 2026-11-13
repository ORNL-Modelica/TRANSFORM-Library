within TRANSFORM.UsersGuide.Conventions;
class Checklist "Checklist for a pull request"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>Before a pull request, for each class that is new or edited:</p>
<ol>
<li>Names follow the Naming page and spell their words out. No public name was renamed.</li>
<li>The class, its parameters, inputs, public variables and components have description strings: a capital letter, no period, no unit, the shortest phrase that keeps the meaning.</li>
<li>A value the user sets is an input in group \"Inputs\", unless it has to be a parameter.</li>
<li>Start values are on the Initialization tab in \"Start Value: ...\" groups, and no default is a number tuned from a run.</li>
<li>New quantities use <code>SI.</code> or <code>SItf.</code> types. No new bare <code>Real</code> for a physical quantity.</li>
<li>Each port's look matches what the component defines there.</li>
<li>The page has a first paragraph and only headings from the fixed list. Every sentence passes the test: it states the promise, not the implementation.</li>
<li>Sources are cited with a key, an entry under \"References\" and a locator.</li>
<li>Comments state what must stay true, in three lines or fewer, on their own line. No history, and no new commented-out code.</li>
<li>An example has <code>TRANSFORM.Icons.Example</code>, an <code>experiment</code> annotation and, if it is a test, a <code>unitTests</code> block that tracks a value the model computes.</li>
</ol>
<p>The two pairs below are made up for this page.</p>
<h4>Declarations in a new class: before</h4>
<pre>parameter Real L=1 \"length [m].\";
parameter Boolean heatport=false \"heat port flag\";
Real Tw[n];</pre>
<h4>After</h4>
<pre>input SI.Length length_heated=1 \"Heated section length\"
  annotation (Dialog(group=\"Inputs\"));
parameter Boolean use_HeatPort=false \"= true to add a heat port\"
  annotation (Dialog(tab=\"Advanced\", group=\"Heat Transfer\"), Evaluate=true);
SI.Temperature Ts_wall[nV] \"Wall temperatures\";</pre>
<h4>A page: before</h4>
<pre>&lt;p&gt;Tank model. Parameters: A (default 1 m2), level_start (default 0.5 m).
The mass balance is der(m) = port.m_flow. Updated June 2020.&lt;/p&gt;</pre>
<h4>After</h4>
<pre>&lt;p&gt;Open liquid tank with one port at its bottom. It computes the level from
the liquid mass, and the port pressure is the surface pressure plus the
liquid head.&lt;/p&gt;
&lt;h4&gt;Assumptions and limits&lt;/h4&gt;
&lt;ul&gt;
&lt;li&gt;The liquid is well mixed.&lt;/li&gt;
&lt;li&gt;The cross-section does not change with height.&lt;/li&gt;
&lt;/ul&gt;</pre>
</html>"));
end Checklist;
