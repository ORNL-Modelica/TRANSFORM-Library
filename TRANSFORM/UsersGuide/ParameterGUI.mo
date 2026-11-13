within TRANSFORM.UsersGuide;
model ParameterGUI "Parameter GUI Guidelines"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>In the parameter window of a component:</p>
<ul>
<li>A value in a group named &quot;Inputs&quot; can be given a number or an expression that changes during a run.</li>
<li>Most other values are parameters, which are fixed during a run.</li>
<li>A drop-down menu selects a replaceable package or model. A replaceable model has values of its own, which can be changed.</li>
</ul>
<p>The rules a developer follows when laying out a parameter window are in <a href=\"modelica://TRANSFORM.UsersGuide.Conventions.ParameterWindow\">Conventions.ParameterWindow</a>.</p>
</html>"));
end ParameterGUI;
