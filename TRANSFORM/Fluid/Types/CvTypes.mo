within TRANSFORM.Fluid.Types;
type CvTypes = enumeration(
    Av "Av (metric) flow coefficient",
    Kv "Kv (metric) flow coefficient",
    Cv "Cv (US) flow coefficient",
    OpPoint "Av defined by operating point")
  "Enumeration to define the choice of valve flow coefficient" annotation (
    Documentation(info="<html>

<p>
Enumeration to define the choice of valve flow coefficient
(to be selected via choices menu):
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>CvTypes.</b></th>
    <th><b>Meaning</b></th></tr>

<tr><td>Av</td>
    <td>Av (metric) flow coefficient</td></tr>

<tr><td>Kv</td>
    <td>Kv (metric) flow coefficient</td></tr>

<tr><td>Cv</td>
    <td>Cv (US) flow coefficient</td></tr>

<tr><td>OpPoint</td>
    <td>Av defined by operating point</td></tr>

</table>

<p>
The details of the coefficients are explained in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">
   User's Guide </a>.
</p>

</html>"));
