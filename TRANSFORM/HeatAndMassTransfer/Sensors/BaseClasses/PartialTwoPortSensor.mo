within TRANSFORM.HeatAndMassTransfer.Sensors.BaseClasses;
partial model PartialTwoPortSensor
  parameter Boolean showName=true "= false to hide component name"
    annotation (Dialog(tab="Visualization"));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow port_a
    "Heat connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow port_b
    "Heat connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
equation
  // Heat balance
  0 = port_a.Q_flow + port_b.Q_flow;
  // Energy equation (no heat loss)
  port_a.T = port_b.T;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PartialTwoPortSensor;
