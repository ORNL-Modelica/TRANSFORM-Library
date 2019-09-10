within TRANSFORM.UsersGuide;
model nParallel
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>The paramerter &quot;nParallel&quot; allows the user to mimic the behavior of multiple, identical components in parallel. The parameter operates on the flow variable (e.g., m_flow or Q_flow) by dividing the port value from the value used in the model. </p>
<p><br>For example,</p>
<p>port_a.m_flow/nParallel = m_flow</p>
<p>port_b.m_flow/nParallel = m_flow</p>
<p><br>An important aspect of this component is to ensure that if values are references within a component, the user multiplies nParallel to that number as appropriate. </p>
<p>For example, if the modeler wants to reference the heat flow from the pipe one may look at &quot;pipe.heatTransfer.heatPorts.Q_flow&quot;. This value is the heat flow from only 1 pipe. So if nParallel is &gt; 1 then the reported value will differ from the expected value by a factor of &quot;nParallel&quot;.</p>
<p><br>So the rule of thumb is, make sure you know what is being referenced and double check that everything makes sense. nParallel is very helpful but can be easily used incorrectly.</p>
</html>"));
end nParallel;
