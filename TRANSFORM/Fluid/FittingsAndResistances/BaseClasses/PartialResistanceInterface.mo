within TRANSFORM.Fluid.FittingsAndResistances.BaseClasses;
partial model PartialResistanceInterface
  "Minimal two-port resistance interface (Medium + ports) shared by the old and new resistance base classes"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  annotation (Documentation(info="<html>
<p>Minimal constraining interface for a two-port fluid resistance, declaring only the
<code>Medium</code> package and the two fluid connectors <code>port_a</code>/<code>port_b</code>.</p>
<p>It is intended to be used as the <code>constrainedby</code> type for a <b>replaceable</b> resistance so that
<i>either</i> base class can be plugged in:</p>
<ul>
<li><a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistance\">PartialResistance</a>
(e.g. <code>PressureLoss</code>, <code>SpecifiedResistance</code>), and</li>
<li><a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew\">PartialResistancenew</a>
(e.g. <code>SharpEdgedAdaptor</code>, <code>SmoothAdaptor</code>, <code>Elbow</code>).</li>
</ul>
<p>Both base classes already declare a compatible <code>Medium</code>, <code>port_a</code> and <code>port_b</code>, so
they satisfy this interface by Modelica structural subtyping without any change to either base class. Components are not
required to <code>extend</code> this interface explicitly &ndash; they only need to provide these named elements.</p>
</html>"), Icon(graphics={Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}));
end PartialResistanceInterface;
