within TRANSFORM.UsersGuide;
package Conventions "Conventions for classes in TRANSFORM"
  extends Modelica.Icons.Information;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>How classes in TRANSFORM are named, described, laid out in the parameter window, documented and commented. The aim is that a user can read any class the same way, and that someone adding a class does not have to guess.</p>
<p>The conventions apply to every new class and to every class that is edited. Existing classes are brought in line in batches. Two limits hold everywhere:</p>
<ul>
<li>A public name is not renamed for style. A public name is any class, parameter, input, variable or connector that a user's model can refer to.</li>
<li>Bringing an existing class in line with this guide changes text only: description strings, documentation and comments. It does not change results. Anything that could, such as a new type for a declaration or a new annotation, is made as a change of its own, with a check of the results.</li>
</ul>
<p>Where the Modelica Standard Library has a different convention, this guide is the one that applies inside TRANSFORM.</p>
<h4>Pages</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>Page</th><th>Covers</th></tr>
<tr><td>Naming</td><td>Classes, instances, variables, suffixes, arrays, switches</td></tr>
<tr><td>Descriptions</td><td>The description string of a class or a declaration</td></tr>
<tr><td>ParameterWindow</td><td>Input or parameter, tabs and groups, start values, optional ports, replaceable models</td></tr>
<tr><td>Units</td><td>Unit types and their two aliases</td></tr>
<tr><td>ConnectorsAndIcons</td><td>How a port's look says what it defines</td></tr>
<tr><td>Documentation</td><td>What a class's page holds, its headings, figures and HTML</td></tr>
<tr><td>References</td><td>Citing a source</td></tr>
<tr><td>Examples</td><td>Examples, tests and reference values</td></tr>
<tr><td>Comments</td><td>Comments in the code</td></tr>
<tr><td>Layout</td><td>Files, indentation and order inside a class</td></tr>
<tr><td>Checklist</td><td>What to check before a pull request</td></tr>
</table>
</html>"));
end Conventions;
