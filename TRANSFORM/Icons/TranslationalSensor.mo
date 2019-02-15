within TRANSFORM.Icons;
partial class TranslationalSensor
  "Icon representing a linear measurement device"
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid,
          extent={{-70,-52},{70,28}}),
        Line(points={{0,20},{0,0}}),
        Line(points={{-70,0},{0,0}}),
        Line(points={{-50,28},{-50,8}}),
        Line(points={{-30,28},{-30,8}}),
        Line(points={{-10,28},{-10,8}}),
        Line(points={{10,28},{10,8}}),
        Line(points={{30,28},{30,8}}),
        Line(points={{50,28},{50,8}}),
        Polygon(
          points={{0,28},{-4,20},{4,20},{0,28}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
This icon is designed for a <b>translational sensor</b> model.
</p></html>"));
end TranslationalSensor;
