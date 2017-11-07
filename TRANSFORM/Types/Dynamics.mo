within TRANSFORM.Types;
type Dynamics = enumeration(
    DynamicFreeInitial
      "DynamicFreeInitial -- Dynamic balance, Initial guess value",
    FixedInitial "FixedInitial -- Dynamic balance, Initial value fixed",
    SteadyStateInitial
      "SteadyStateInitial -- Dynamic balance, Steady state initial with guess value",
    SteadyState "SteadyState -- Steady state balance, Initial guess value")
  "Enumeration to define definition of balance equations"
annotation (Documentation(info="<html>
<p>Enumeration to define the formulation of balance equations (to be selected via choices menu): </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td><p align=\"center\"><h4>Dynamics.</h4></p></td>
<td><p align=\"center\"><h4>Meaning</h4></p></td>
</tr>
<tr>
<td><p>DynamicFreeInitial</p></td>
<td><p>Dynamic balance, Initial guess value</p></td>
</tr>
<tr>
<td><p>FixedInitial</p></td>
<td><p>Dynamic balance, Initial value fixed</p></td>
</tr>
<tr>
<td><p>SteadyStateInitial</p></td>
<td><p>Dynamic balance, Steady state initial with guess value</p></td>
</tr>
<tr>
<td><p>SteadyState</p></td>
<td><p>Steady state balance, Initial guess value</p></td>
</tr>
</table>
<p><br>The enumeration &QUOT;Dynamics&QUOT; is used for the transient behavior initializations such as mass, energy and momentum balances. The exact meaning of the three balance equations is stated in the following tables using fluid flow as an example: </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td colspan=\"3\"><p><b>Mass balance</b> </p></td>
</tr>
<tr>
<td><h4>Dynamics.</h4></td>
<td><h4>Balance equation</h4></td>
<td><h4>Initial condition</h4></td>
</tr>
<tr>
<td><p>DynamicFreeInitial</p></td>
<td><p>no restrictions </p></td>
<td><p>no initial conditions </p></td>
</tr>
<tr>
<td><p>FixedInitial</p></td>
<td><p>no restrictions </p></td>
<td><p><b>if</b> Medium.singleState <b>then</b> </p><p>&nbsp;&nbsp;no initial condition</p><p><b>else</b> p=p_start </p></td>
</tr>
<tr>
<td><p>SteadyStateInitial</p></td>
<td><p>no restrictions </p></td>
<td><p><b>if</b> Medium.singleState <b>then</b> </p><p>&nbsp;&nbsp;no initial condition</p><p><b>else</b> <b>der</b>(p)=0 </p></td>
</tr>
<tr>
<td><p>SteadyState</p></td>
<td><p><b>der</b>(m)=0 </p></td>
<td><p>no initial conditions </p></td>
</tr>
</table>
<p><br>&nbsp;</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td colspan=\"3\"><p><b>Energy balance</b> </p></td>
</tr>
<tr>
<td><h4>Dynamics.</h4></td>
<td><h4>Balance equation</h4></td>
<td><h4>Initial condition</h4></td>
</tr>
<tr>
<td><p>DynamicFreeInitial</p></td>
<td><p>no restrictions </p></td>
<td><p>no initial conditions </p></td>
</tr>
<tr>
<td><p>FixedInitial</p></td>
<td><p>no restrictions </p></td>
<td><p>T=T_start or h=h_start </p></td>
</tr>
<tr>
<td><p>SteadyStateInitial</p></td>
<td><p>no restrictions </p></td>
<td><p><b>der</b>(T)=0 or <b>der</b>(h)=0 </p></td>
</tr>
<tr>
<td><p>SteadyState</p></td>
<td><p><b>der</b>(U)=0 </p></td>
<td><p>no initial conditions </p></td>
</tr>
</table>
<p><br>&nbsp;</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td colspan=\"3\"><p><b>Momentum balance</b> </p></td>
</tr>
<tr>
<td><h4>Dynamics.</h4></td>
<td><h4>Balance equation</h4></td>
<td><h4>Initial condition</h4></td>
</tr>
<tr>
<td><p>DynamicFreeInitial</p></td>
<td><p>no restrictions </p></td>
<td><p>no initial conditions </p></td>
</tr>
<tr>
<td><p>FixedInitial</p></td>
<td><p>no restrictions </p></td>
<td><p>m_flow = m_flow_start </p></td>
</tr>
<tr>
<td><p>SteadyStateInitial</p></td>
<td><p>no restrictions </p></td>
<td><p><b>der</b>(m_flow)=0 </p></td>
</tr>
<tr>
<td><p>SteadyState</p></td>
<td><p><b>der</b>(m_flow)=0 </p></td>
<td><p>no initial conditions </p></td>
</tr>
</table>
<p><br>In the tables above, the equations are given for one-substance fluids. For multiple-substance fluids and for trace substances, equivalent equations hold. </p>
<p>Medium.singleState is a medium property and defines whether the medium is only described by one state (+ the mass fractions in case of a multi-substance fluid). In such a case one initial condition less must be provided. For example, incompressible media have Medium.singleState = <b>true</b>. </p>
</html>"));
