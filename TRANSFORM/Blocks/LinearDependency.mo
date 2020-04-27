within TRANSFORM.Blocks;
block LinearDependency
  "Output a linear combination of the two inputs"
  extends Modelica.Blocks.Interfaces.SI2SO;
  input Real k0=1 "Scale" annotation(Dialog(group="Input"));
  input Real k1=1 "u1 dependency" annotation(Dialog(group="Input"));
  input Real k2=1 "u2 dependency" annotation(Dialog(group="Input"));
  Real k1u1=k1*u1;
  Real k2u2=k2*u2;
equation
  y = k0*(k1u1 + k2u2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{-100,60},{100,0},{-100,-60}},
          color={0,0,127}),
        Text(
          extent={{-14,88},{94,32}},
          textString="%k1"),
        Text(
          extent={{-40,-48},{96,-96}},
          textString="%k2"),
        Text(
          extent={{-94,26},{8,-30}},
          textString="%k0")}), Documentation(info="<html>
<p>Determine the linear combination of the two inputs: <code>y = k0*(k1*u1 + k2*u2)</code></p>
<p><strong>Note</strong>, for k0=0 the output is always zero.</p>
</html>"));
end LinearDependency;
