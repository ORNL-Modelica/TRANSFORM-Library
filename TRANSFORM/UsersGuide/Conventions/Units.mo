within TRANSFORM.UsersGuide.Conventions;
class Units "Unit types"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>Among its imports, the root package of TRANSFORM has two aliases for unit types. Every class in the library can use them without an import of its own:</p>
<pre>import Modelica.Units.SI;
import SItf = TRANSFORM.Units;</pre>
<ul>
<li>A physical quantity uses a type from <code>SI.</code>: <code>SI.Temperature</code>, <code>SI.MassFlowRate</code>.</li>
<li>A quantity that <code>SI.</code> has no type for uses one of TRANSFORM's own, always through the alias: <code>SItf.ExtraProperty</code>. It is not written <code>Units.ExtraProperty</code> or <code>TRANSFORM.Units.ExtraProperty</code>.</li>
<li>A new physical quantity is not declared as a bare <code>Real</code>. A dimensionless one is <code>SItf.NonDim</code>.</li>
<li>In an existing class, giving a bare <code>Real</code> a unit type is not a text-only change: the type brings <code>min</code>, <code>start</code> and <code>nominal</code> values with it. It is made as a change of its own, with a check of the results.</li>
<li>A component declares its quantities in SI types and sets no <code>displayUnit</code>. An example or a user's model may set one.</li>
<li>A signal in a control block may be a plain <code>Real</code>. Its description then says what it stands for.</li>
</ul>
<h4>The earlier alias</h4>
<p><code>SIadd</code> is the earlier name of the same alias. The root package still imports it, so existing classes keep working, and they are reworded to <code>SItf</code> in batches. New and edited code uses <code>SItf</code>.</p>
<h4>In a library built on TRANSFORM</h4>
<p>An import is seen only inside the library that declares it. A library built on TRANSFORM puts the same two lines in its own root package. Its unit types then read the same as TRANSFORM's.</p>
</html>"));
end Units;
