within TRANSFORM.UsersGuide;
model ParameterGUI "Parameter GUI Guidelines"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>&quot;Inputs&quot; groups in the GUI indicate can be time varying</p>
<p>&quot;Parameters&quot; or unspecified groups are parameters class unles they are a replaceable model then refer to the contents in the model</p>
<p><br>Dropdown menu can indicate a replaceable package or model. Models permit their values to be changed.</p>
</html>"));
end ParameterGUI;
