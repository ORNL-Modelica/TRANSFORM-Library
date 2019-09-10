within TRANSFORM.Icons;
partial class MultiSensor_2values
  "Icon representing a measurement device"
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-50,50},{50,0}},
          lineColor={0,0,0},
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,0},{50,-50}},
          lineColor={0,0,0},
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This icon is designed for a <b>rotational sensor</b> model.
</p>
</html>"));
end MultiSensor_2values;
