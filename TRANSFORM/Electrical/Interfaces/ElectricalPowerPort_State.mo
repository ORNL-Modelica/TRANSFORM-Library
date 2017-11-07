within TRANSFORM.Electrical.Interfaces;
connector ElectricalPowerPort_State
  "Electrical power connector at state/non-flow port"
  extends TRANSFORM.Electrical.Interfaces.ElectricalPowerPort;
  annotation (defaultComponentName="port_b",
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
        extent={{-40,40},{40,-40}},
        lineColor={255,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-150,110},{150,50}}, textString="%name")}),
       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-32,26},{30,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
        extent={{-100,100},{100,-100}},
        lineColor={255,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Temporary connector until decision on how to exchange &QUOT;electrical power&QUOT;.... Want to specify V and I? what about 2 phase or 3 phase...</span></p>
</html>"));
end ElectricalPowerPort_State;
