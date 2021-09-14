within TRANSFORM.Fluid;
model TemporaryBlock_Fluid
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}}),
        iconTransformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
        iconTransformation(extent={{60,-10},{80,10}})));

  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));

equation

  port_a.m_flow + port_b.m_flow = 0;
  port_a.p = port_b.p;

  // Stream variables balance
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (defaultComponentName="temporary",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName)),
        Line(
          points={{-60,0},{60,0}},
          color={28,108,200},
          thickness=1)}),    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TemporaryBlock_Fluid;
