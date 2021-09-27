within TRANSFORM.Electrical.Sensors;
model FrequencySensor "Measures the frequency at the connector"
  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=f,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Frequency_Hz.to_Hz
      constrainedby TRANSFORM.Units.Conversions.Functions.Frequency_Hz.BaseClasses.to);
  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow port annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=0),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput f(
    min=0,
    final quantity="Frequency",
    final unit="1/s",
    displayUnit="1/s")
           "Pressure at port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  port.W = 0;
  f = port.f;
  annotation (Icon(graphics={
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={255,0,0}),
                                                       Text(extent={{-148,72},{
              152,112}},
          textString="%name",
          lineColor={238,46,47}),
        Text(
          extent={{137,50},{43,20}},
          lineColor={0,0,0},
          textString="f")}));
end FrequencySensor;
