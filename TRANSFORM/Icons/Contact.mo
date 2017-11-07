within TRANSFORM.Icons;
partial class Contact "Icon for contact information"

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,70},{100,-72}},
          lineColor={0,0,0},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-72},{100,-72},{0,20},{-100,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{22,0},{100,70},{100,-72},{22,0}},
          lineColor={0,0,0},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,70},{100,70},{0,-20},{-100,70}},
          lineColor={0,0,0},
          fillColor={241,241,241},
          fillPattern=FillPattern.Solid)}),
                            Documentation(info="<html>
<p>This icon shall be used for the contact information of the library developers.</p>
</html>"));
end Contact;
