within TRANSFORM.UsersGuide.Conventions;
class Documentation "What the page of a class holds"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>The code is the definitive answer on what a class does. Its page holds what the code cannot say: what the class represents, when it is valid, where it comes from and how to set it up.</p>
<p>Every public class that is not partial has a page with at least a first paragraph.</p>
<h4>The test for a sentence</h4>
<p>Document the promise, not the implementation. For any sentence, ask: could someone change the equation section, keep what the class promises, and make this sentence false? If so, it does not belong on the page.</p>
<ul>
<li>Never on the page: default values, a list of the class's parameters or variables with their meanings (the tool builds that from the description strings), how a balance is arranged, which smoothing function is used.</li>
<li>A name from the code appears only where the reader has to use it: a value to set (<code>massDynamics=FixedInitial</code>), a port to connect, a variable to look at, or a term of an equation that is shown.</li>
<li>A number appears when it is part of what the class promises: a validity range, or the coefficient that identifies a published correlation.</li>
<li>An equation appears only when it is the class's identity, as for a correlation, and only if the description string does not already carry it. It is written as text in the model's own variable names, not as a picture.</li>
<li>A relation in words is fine when it defines the behaviour: \"the port pressure is the surface pressure plus the liquid head\".</li>
</ul>
<h4>The shape of a page</h4>
<ol>
<li>A first paragraph with no heading, three sentences at most: what physical thing or calculation this is, what it computes from what, and how it differs from its nearest neighbour. It can be read alone.</li>
<li>A figure, where words define symbols poorly: geometry, node numbering, sign conventions.</li>
<li>Headings from the table below, in that order. A heading appears only when it has content. No other headings are used.</li>
</ol>
<p>Documentation is not inherited. Classes that share a base class each state the shared behaviour, briefly and in the same words.</p>
<p>In the table, \"yes\" means the heading is expected for that kind of class and \"if needed\" means it is used when there is something to say. An empty cell means it is not used.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Heading, in page order</th><th>Component</th><th>Correlation</th><th>Material or medium</th><th>Function</th><th>Example</th><th>Validation example</th><th>Package</th></tr>
<tr><td>Choosing</td><td></td><td></td><td></td><td></td><td></td><td></td><td>if needed</td></tr>
<tr><td>Equations</td><td>if needed</td><td>if needed</td><td>if needed</td><td>if needed</td><td></td><td></td><td></td></tr>
<tr><td>Assumptions and limits</td><td>if needed</td><td>yes</td><td>yes</td><td>if needed</td><td></td><td></td><td></td></tr>
<tr><td>Use</td><td>if needed</td><td>if needed</td><td>if needed</td><td></td><td></td><td></td><td></td></tr>
<tr><td>What to look at</td><td></td><td></td><td></td><td></td><td>if needed</td><td>if needed</td><td></td></tr>
<tr><td>Reference case</td><td></td><td></td><td></td><td></td><td></td><td>yes</td><td></td></tr>
<tr><td>Expected results</td><td></td><td></td><td></td><td></td><td></td><td>yes</td><td></td></tr>
<tr><td>Differences from the reference</td><td></td><td></td><td></td><td></td><td></td><td>if needed</td><td></td></tr>
<tr><td>Implementation</td><td>if needed</td><td>if needed</td><td>if needed</td><td>if needed</td><td></td><td></td><td></td></tr>
<tr><td>References</td><td>if needed</td><td>yes</td><td>yes</td><td>if needed</td><td></td><td>yes</td><td></td></tr>
</table>
<h4>What each heading holds</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Heading</th><th>Holds</th></tr>
<tr><td>Choosing</td><td>For a package: a table that says which class to pick for which case</td></tr>
<tr><td>Equations</td><td>The relation that defines the class, where it passes the test above</td></tr>
<tr><td>Assumptions and limits</td><td>What the class assumes and where it stops being valid. For a correlation or a material this is a table of quantity, range and source. Where the code asserts or warns on a range, the table gives the same numbers</td></tr>
<tr><td>Use</td><td>How to set the class up, how to start it, what it should be connected to</td></tr>
<tr><td>What to look at</td><td>Which variables show the point of the example</td></tr>
<tr><td>Reference case</td><td>The published case being reproduced, with its given data</td></tr>
<tr><td>Expected results</td><td>A table of each quantity and the model variable that holds it. The reference values are the entries of <code>unitTests.x_reference</code>, in the same order</td></tr>
<tr><td>Differences from the reference</td><td>Why the model cannot match exactly, such as printed property tables against a property formulation, or an error in the source</td></tr>
<tr><td>Implementation</td><td>Why the class is written the way it is, for someone changing the code</td></tr>
<tr><td>References</td><td>The sources, as the References page describes</td></tr>
</table>
<h4>Nothing that ages</h4>
<ul>
<li>No history and no list of revisions. History is in CHANGELOG.md.</li>
<li>No measurements, run times or tool versions.</li>
<li>No links to issues or to examples.</li>
</ul>
<h4>Text taken over from another library</h4>
<p>It is corrected until it describes this class, or it is cut. The credit to where the class came from stays.</p>
<h4>HTML</h4>
<ul>
<li>Use <code>&lt;p&gt;</code>, <code>&lt;h4&gt;</code> for headings, <code>&lt;code&gt;</code> for names and values, <code>&lt;ul&gt;</code>, <code>&lt;ol&gt;</code>, <code>&lt;table&gt;</code> and <code>&lt;pre&gt;</code>.</li>
<li>No <code>&lt;h1&gt;</code> to <code>&lt;h3&gt;</code>, no <code>&lt;font&gt;</code> or <code>&lt;span&gt;</code> styling, no <code>&lt;tt&gt;</code>.</li>
<li>A figure is stored under <code>Resources/Images</code> in a folder that mirrors the package path, linked as <code>modelica://TRANSFORM/Resources/Images/...</code>, and has <code>alt</code> text.</li>
<li>American spelling.</li>
</ul>
</html>"));
end Documentation;
