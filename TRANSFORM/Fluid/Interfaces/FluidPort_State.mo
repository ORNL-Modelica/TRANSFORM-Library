within TRANSFORM.Fluid.Interfaces;
connector FluidPort_State
  "Generic fluid connector for defined state/non-flow variable (e.g., pressure - p)"
  extends Modelica.Fluid.Interfaces.FluidPort;
  annotation (
    defaultComponentName="port_b",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{-150,110},{150,50}}, textString="%name")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{40,20},{80,-20}},
          lineColor={0,127,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end FluidPort_State;
