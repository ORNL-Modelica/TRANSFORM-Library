within TRANSFORM.Electrical.Interfaces;
connector ElectricalPowerPort_Flow
  "Electrical power connector at flow port"
  extends TRANSFORM.Electrical.Interfaces.ElectricalPowerPort;
  annotation (defaultComponentName="port_a",
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Ellipse(
        extent={{-42,40},{38,-40}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Text(extent={{-150,110},{150,50}},
            textString="%name")}),
       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Ellipse(
          extent={{-32,30},{28,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid), Ellipse(
        extent={{-100,100},{100,-100}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
  Documentation(info="<html>
<p>Temporary connector until decision on how to exchange &QUOT;electrical power&QUOT;.... Want to specify V and I? what about 2 phase or 3 phase...</p>
</html>"));
end ElectricalPowerPort_Flow;
