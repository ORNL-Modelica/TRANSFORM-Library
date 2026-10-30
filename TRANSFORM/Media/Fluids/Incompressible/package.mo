within TRANSFORM.Media.Fluids;
package Incompressible "Medium model for T-dependent properties, defined by tables or polynomials"
  extends Modelica.Icons.VariantsPackage;
  import Modelica.Constants;
  import Modelica.Math;

  annotation (
    Documentation(info="<HTML>
<h4>Incompressible media package</h4>
<p>
This package provides a structure and examples of how to create simple
medium models of incompressible fluids, meaning fluids with very little
pressure influence on density. The medium properties is typically described
in terms of tables, functions or polynomial coefficients.
</p>
<h4>Definitions</h4>
<p>
The common meaning of <em>incompressible</em> is that properties like density
and enthalpy are independent of pressure. Thus properties are conveniently
described as functions of temperature, e.g., as polynomials density(T) and cp(T).
However, enthalpy can not be independent of pressure since h = u - p/d. For liquids
it is anyway
common to neglect this dependence since for constant density the neglected term
is (p - p0)/d, which in comparison with cp is very small for most liquids. For
water, the equivalent change of temperature to increasing pressure 1 bar is
0.025 Kelvin.
</p>
<p>
Two Boolean flags are used to choose how enthalpy and inner energy is calculated:
</p>
<ul>
<li><b>enthalpyOfT</b>=true, means assuming that enthalpy is only a function
of temperature, neglecting the pressure dependent term.</li>
<li><b>singleState</b>=true, means also neglect the pressure influence on inner
energy, which makes all medium properties pure functions of temperature.</li>
</ul>
<p>
The default setting for both these flags is true, which enables the simulation tool
to choose temperature as the only medium state and avoids non-linear equation
systems, see the section about
<a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition.StaticStateSelection\">Static
state selection</a> in the Modelica.Media User's Guide.
</p>

<h4>Contents</h4>
<p>
Currently, the package contains the following parts:
</p>
<ol>
<li> <a href=\"modelica://Modelica.Media.Incompressible.TableBased\">
      Table based medium models</a></li>
<li> <a href=\"modelica://Modelica.Media.Incompressible.Examples\">
      Example medium models</a></li>
</ol>

<p>
A few examples are given in the Examples package. The model
<a href=\"modelica://Modelica.Media.Incompressible.Examples.Glycol47\">
Examples.Glycol47</a> shows how the medium models can be used. For more
realistic examples of how to implement volume models with medium properties
look in the <a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage\">Medium
usage section</a> of the User's Guide.
</p>

</HTML>"));
end Incompressible;
