within TRANSFORM.Utilities.Visualizers.BaseClasses.Types;
type LinePattern = enumeration(
    Dash,
    DashDot,
    DashDotDot,
    Default,
    Dot,
    None,
    Solid)
  "Enumeration to define definition of balance equations"
annotation (Documentation(info="<html>
<p>
Enumeration to define the formulation of balance equations
(to be selected via choices menu):
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>Dynamics.</b></th><th><b>Meaning</b></th></tr>
<tr><td>DynamicFreeInitial</td><td>Dynamic balance, Initial guess value</td></tr>

<tr><td>FixedInitial</td><td>Dynamic balance, Initial value fixed</td></tr>

<tr><td>SteadyStateInitial</td><td>Dynamic balance, Steady state initial with guess value</td></tr>

<tr><td>SteadyState</td><td>Steady state balance, Initial guess value</td></tr>
</table>

<p>
The enumeration \"Dynamics\" is used for the mass, energy and momentum balance equations
respectively. The exact meaning for the three balance equations is stated in the following
tables:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Mass balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> p=p_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> <b>der</b>(p)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Energy balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> T=T_start or h=h_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(T)=0 or <b>der</b>(h)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(U)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Momentum balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> m_flow = m_flow_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(m_flow)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m_flow)=0 </td>
    <td> no initial conditions </td></tr>
</table>

<p>
In the tables above, the equations are given for one-substance fluids. For multiple-substance
fluids and for trace substances, equivalent equations hold.
</p>

<p>
Medium.singleState is a medium property and defines whether the medium is only
described by one state (+ the mass fractions in case of a multi-substance fluid). In such
a case one initial condition less must be provided. For example, incompressible
media have Medium.singleState = <b>true</b>.
</p>

</html>"));
