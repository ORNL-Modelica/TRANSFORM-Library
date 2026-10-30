within TRANSFORM.Units;
package Conversions
annotation (Documentation(info="<html>
<p>This package contains unit conversion functions and a model with a replaceable function call to assist the user. If a desired unit is not available, it may be added.</p>
<p>However ensure that there does not already exist an appropriate alternative. For example Internal energy and enthalpy both have units of [J]. There only exists an &quot;Energy&quot; package as the unit is the same between them.</p>
<p>If adding new units within an exising package, you must adopt the naming conventions of to/from and provide BOTH the to and from functions. Once the functions are implemented provide a unit test for the newly implmented function.</p>
</html>"));
end Conversions;
