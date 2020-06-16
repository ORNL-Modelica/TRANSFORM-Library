within TRANSFORM.Blocks.Logical;
block Latch
  "Latches Boolean input to be True forever once it is True for the first time"
  extends Modelica.Blocks.Interfaces.partialBooleanSISO;
equation
  y = u or pre(y);
  annotation (
    defaultComponentName="latch1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          textString="latch",
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>The output is <b>true</b> if at input has ever been <b>true</b>, otherwise the output is <b>false</b>. </p>
</html>"));
end Latch;
