within TRANSFORM.UsersGuide.Conventions;
class Examples "Examples, tests and reference values"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<h4>Every example</h4>
<ul>
<li>It extends <code>TRANSFORM.Icons.Example</code>.</li>
<li>It has an <code>experiment</code> annotation with a <code>StopTime</code>, so it runs as intended with no settings.</li>
<li>It declares its medium once at the top and uses that name in every <code>redeclare</code>.</li>
<li>When it is new or edited, each component has a description that says its role in the scenario, as the Descriptions page says.</li>
</ul>
<h4>Names</h4>
<ul>
<li>An example's name says its purpose and stays short.</li>
<li>A simple example that only exercises one component is named after it with <code>_Test</code>: <code>SimpleVolume_Test</code>.</li>
<li>A simple check of a function is named <code>check_</code> followed by the function: <code>check_spliceTanh</code>.</li>
<li>Where several examples serve the same purpose for different components, they share one naming pattern.</li>
</ul>
<h4>An example that is also a test</h4>
<ul>
<li>It holds one block that names the variables to track:
<pre>TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={volume.medium.p, volume.medium.T});</pre></li>
<li>It tracks at least one value the model computes, not only values a boundary condition fixes.</li>
<li>It exercises what it tracks. If a tracked signal is too small to compare, change the example so that it moves the signal. Do not scale the quantity, change its nominal value or tighten a tolerance to lift it.</li>
<li>A regression test that is not useful as an example goes in the test library, TRANSFORMTest, not in TRANSFORM.</li>
</ul>
<h4>Reference values</h4>
<p><code>unitTests.x_reference</code> holds the value each tracked variable should have, in the same order as <code>x</code>. It lets someone running the example see the reference beside the model's value. It does not stop or fail a run.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>The reference is</th><th>Where it lives</th></tr>
<tr><td>A few fixed numbers, such as a book's answers</td><td>Written in the example, in <code>x_reference</code></td></tr>
<tr><td>A formula, such as an analytic solution</td><td>Written in the example</td></tr>
<tr><td>A table or a curve</td><td>One text file under <code>Resources/data</code>, in a folder that mirrors the package path, loaded by a table block</td></tr>
</table>
<ul>
<li>A data file is in the Modelica Standard Library's text table format. Its first line is <code>#1</code>, as that format requires. Comment lines follow: the source, the unit of each column, and how the file was made.</li>
<li>A script that made a data file is kept under <code>Resources/python</code> as a record of where the data came from.</li>
<li>Nothing regenerates a reference during testing. Changing a reference is a reviewed change, like accepting a new test baseline.</li>
</ul>
<h4>A validation example</h4>
<p>A validation example reproduces a published case, such as a worked example from a textbook.</p>
<ul>
<li>Its name and description say what the case is. The source's example number goes in the documentation.</li>
<li>Its page uses the headings \"Reference case\", \"Expected results\" and \"References\", and \"Differences from the reference\" where the model cannot match exactly.</li>
<li>The source's values are written once, in <code>x_reference</code>. The \"Expected results\" table names each quantity and the model variable that holds it.</li>
<li>The reference cites the example number and the page.</li>
</ul>
</html>"));
end Examples;
