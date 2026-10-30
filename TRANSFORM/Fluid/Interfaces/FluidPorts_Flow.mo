within TRANSFORM.Fluid.Interfaces;
connector FluidPorts_Flow
  "Generic fluid connector for vectors of FluidPorts defining flow variable (e.g., mass flow rate - m_flow). Vector dimensions must be added after dragging."
  extends Fluid.Interfaces.FluidPort;
  annotation (
    defaultComponentName="ports_a",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-50,-200},{50,200}}), graphics={
        Text(extent={{-75,130},{75,100}}, textString="%name"),
        Rectangle(extent={{25,-100},{-25,100}}, lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,90},{25,40}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,25},{25,-25}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,-40},{25,-90}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-50,-200},{50,200}}), graphics={
                  Ellipse(
          extent={{-22,20},{18,-20}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,-200},{-50,200}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,180},{50,80}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,50},{50,-50}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,-80},{50,-180}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid)}));
end FluidPorts_Flow;
