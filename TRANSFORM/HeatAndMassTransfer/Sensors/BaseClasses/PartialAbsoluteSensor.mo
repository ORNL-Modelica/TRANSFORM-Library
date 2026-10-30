within TRANSFORM.HeatAndMassTransfer.Sensors.BaseClasses;
partial model PartialAbsoluteSensor
  "Partial component to model a sensor that measures a potential variable"
  parameter Boolean showName=true "= false to hide component name"
    annotation (Dialog(tab="Visualization"));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow port
    "Heat connector"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=
           0), iconTransformation(extent={{-10,-110},{10,-90}})));
equation
  port.Q_flow = 0;
  annotation (Documentation(info="<html>
<p>Partial component to model an <b>absolute sensor</b>. Can be used for temperature sensor models.</p>
</html>"), Icon(graphics={
        Text(
          extent={{-149,112},{151,72}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}));
end PartialAbsoluteSensor;
