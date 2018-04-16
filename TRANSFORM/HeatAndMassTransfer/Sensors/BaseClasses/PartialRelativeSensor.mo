within TRANSFORM.HeatAndMassTransfer.Sensors.BaseClasses;
model PartialRelativeSensor
  "Partial component to model a sensor that measures the difference between two potential variables"

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
  // Zero flow equations for connectors
  port_a.Q_flow = 0;
  port_b.Q_flow = 0;

 annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})),
    Icon(graphics={
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}),
    Documentation(info="<html>
<p>
The relative temperature \"port_a.T - port_b.T\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end PartialRelativeSensor;
