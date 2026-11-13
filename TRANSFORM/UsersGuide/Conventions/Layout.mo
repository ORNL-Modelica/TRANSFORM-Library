within TRANSFORM.UsersGuide.Conventions;
class Layout "Files and code layout"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<h4>Files</h4>
<ul>
<li>One class per file, in a file named after the class. Packages of media or of data records may keep their classes in one file.</li>
<li>Every package folder has a <code>package.order</code> file that lists its classes. The tool writes it.</li>
</ul>
<h4>Inside a class</h4>
<ul>
<li>Indent by two spaces. No tab characters.</li>
<li>Imports come first, then <code>extends</code>, then declarations, then the <code>equation</code> section. The class annotation comes last.</li>
<li>In a new class, declare in the order a user meets them: the medium and replaceable models, then parameters and inputs, then connectors and components, then variables. Protected declarations follow the public ones.</li>
<li>Line breaks and graphical annotations are left to the tool.</li>
</ul>
<h4>Existing files</h4>
<p>An existing file is not reordered or reformatted to match this page. A change to a class touches the lines it needs to.</p>
</html>"));
end Layout;
