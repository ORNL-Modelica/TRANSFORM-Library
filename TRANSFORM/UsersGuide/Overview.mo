within TRANSFORM.UsersGuide;
model Overview "Overview of the TRANSFORM Library"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>Two conventions help in reading any component of the library:</p>
<ul>
<li>The look of a port says what the component defines there. A filled port defines the flow through it (for example mass flow rate or heat flow rate). A white port defines the state at it (for example pressure or temperature). The usual connection joins a filled port to a white port. See <a href=\"modelica://TRANSFORM.UsersGuide.Connectors\">Connectors</a>.</li>
<li>In the parameter window, a value in a group named &quot;Inputs&quot; can be given an expression that changes during a run. See <a href=\"modelica://TRANSFORM.UsersGuide.ParameterGUI\">ParameterGUI</a>.</li>
</ul>
<p>How classes are named, described and documented is in <a href=\"modelica://TRANSFORM.UsersGuide.Conventions\">Conventions</a>.</p>
</html>"));
end Overview;
