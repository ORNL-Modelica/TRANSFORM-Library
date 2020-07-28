within TRANSFORM.Blocks.Logical;
block LatchHold "Latches output based on input and trigger"
  extends Modelica.Blocks.Interfaces.SISO;

  Real c "Value when trigger is activated";

  Modelica.Blocks.Interfaces.BooleanInput trigger "Latch trigger"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

initial equation
  y=u;

equation

  y = if trigger then c else u;

  when trigger then
    c = pre(u);
  end when;

  annotation (
    defaultComponentName="latch",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{54,40},{88,40}}),
        Line(points={{-88,-68},{84,-68}}, color={192,192,192}),
        Polygon(
          points={{92,-68},{70,-60},{70,-76},{92,-68}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,70},{-78,-78}}, color={192,192,192}),
        Polygon(
          points={{-78,92},{-86,70},{-70,70},{-78,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,-68},{-60,-68},{-36,-36},{-16,-36},{8,0},{28,0},{54,40}}),
        Line(points={{-78,14},{-60,14},{-60,-14},{-36,-14},{-36,14},{-16,14},{-16,
              -14},{8,-14},{8,14},{28,14},{28,-14},{54,-14},{54,14},{88,14}},
            color={255,0,255})}),
    Documentation(info="<html>
<p>The output follows the input when the trigger is false and holds constant at the previous input value when the trigger is true.</p>
</html>"));
end LatchHold;
