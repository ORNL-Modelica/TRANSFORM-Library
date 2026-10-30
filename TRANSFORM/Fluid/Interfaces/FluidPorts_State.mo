within TRANSFORM.Fluid.Interfaces;
connector FluidPorts_State
  "Generic fluid connector for vectors of FluidPorts defining state/non-flow variable (e.g., pressure - p). Vector dimensions must be added after dragging."
  extends Modelica.Fluid.Interfaces.FluidPort;
  annotation (
    defaultComponentName="ports_b",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-50,-200},{50,200}}), graphics={
        Text(extent={{-75,130},{75,100}}, textString="%name"),
        Rectangle(extent={{-25,100},{25,-100}}, lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,90},{25,40}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,25},{25,-25}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-25,-40},{25,-90}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-50,-200},{50,200}}), graphics={
                  Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,200},{50,-200}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,180},{50,80}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,50},{50,-50}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,-80},{50,-180}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end FluidPorts_State;
