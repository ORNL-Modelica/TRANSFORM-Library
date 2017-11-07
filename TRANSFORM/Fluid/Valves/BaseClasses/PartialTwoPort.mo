within TRANSFORM.Fluid.Valves.BaseClasses;
partial model PartialTwoPort "Partial component with two ports"

  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean showDesignFlowDirection=true
    "= false to hide the flow direction arrow"
    annotation (Dialog(tab="Visualization"));
  parameter Boolean showName=true "= false to hide component name"
    annotation (Dialog(tab="Visualization"));

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(
                                redeclare package Medium = Medium,
                     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(
                                redeclare package Medium = Medium,
                     m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}), iconTransformation(extent={{110,-10},{90,10}})));

  annotation (Icon(graphics={
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true, showDesignFlowDirection)),
        Polygon(
          points={{20,-50},{50,-60},{20,-70},{20,-50}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true, showDesignFlowDirection)),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true, showDesignFlowDirection)),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}));
end PartialTwoPort;
