within TRANSFORM.Blocks.Logical;
block Latch
  "Latches Boolean input to be True forever once it is True for the first time"
  extends Modelica.Blocks.Interfaces.partialBooleanSISO;

equation
  y = u or pre(y);

  annotation (
    defaultComponentName="latch",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
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
                                   Text(
          extent={{-90,40},{90,-40}},
          textString="latch",
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>The output is <b>true</b> if at input has ever been <b>true</b>, otherwise the output is <b>false</b>. </p>
</html>"));
end Latch;
