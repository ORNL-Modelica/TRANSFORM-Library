within TRANSFORM.UsersGuide;
model Connectors
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>For connectors which contain both flow and non-flow components, the TRANSFORM library adopts a default GUI structure to help guide the user on what, generally, should and should not be connected.</p>
<p>The table below presents examples of flow, non-flow, and stream variables. Typically, flow variables contain the suffix of &quot;_flow&quot; as an identifier.</p>
<h4>Table 1. Examples of Connector Variables</h4>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"20%\"><tr>
<td><p>Connector</p></td>
<td><p>Flow</p></td>
<td><p>Non-Flow</p></td>
<td><p>Stream</p></td>
</tr>
<tr>
<td><p>Fluid</p></td>
<td><p>m_flow</p></td>
<td><p>p</p></td>
<td><p>h, Xi, C</p></td>
</tr>
<tr>
<td><p>Heat Transfer</p></td>
<td><p>Q_flow</p></td>
<td><p>T</p></td>
<td><p>N/A</p></td>
</tr>
<tr>
<td><p>Mass Transfer</p></td>
<td><p>n_flow</p></td>
<td><p>C</p></td>
<td><p>N/A</p></td>
</tr>
</table>
<p><br><br>Figure 1 shows the adopted GUI visual ques and recommended connection method. For components which define a non-flow variable at the connection to have a connector symbol filled solid white with the connector color as an outline and those which define a flow variable to be solid filled with the connector color. Discretized models place a oval filled white with a border the color of the connector behind the connection point to provide a visual que to the user. This method is required based on current limitations to Modelca/IDEs and may be simplified in the future if possible. </p>
<p>NOTE 1: Discritized models which have a connection along the discritized dimension do not generally have a visual que indicating that it is an array/matrix. However, attempting to connect the IDE should provide a dialog that is self-evident. The user can then define the connection there or in the text layer.</p>
<p>NOTE 2: Recommended connections are guidelines and not as strict requirements as. However, typically the restriction on connecting non-flow connectors together is fairly strict and will cause models to fail and introduce non-linearities into the solution. Connection of flow connectors is not as restrictive due to the equations auto-generated with the connect() statements.</p>
<p><br><img src=\"modelica://TRANSFORM/Resources/Images/Information/Connectors_flowAndnonflow.jpg\"/></p>
<h4>Figure 1. GUI visual que to help guide the user on proper connections</h4>
</html>"));
end Connectors;
