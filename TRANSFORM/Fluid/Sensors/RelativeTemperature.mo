within TRANSFORM.Fluid.Sensors;
model RelativeTemperature "Ideal relative temperature sensor"
  extends BaseClasses.PartialRelativeSensor;
  extends BaseClasses.PartialRelativeIcon_withValueIndicator(final var=T_rel,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK.to_degC_diff
      constrainedby
      TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput T_rel(final quantity="ThermodynamicTemperature",
                                              final unit = "K", displayUnit = "degC", min=0)
    "Relative temperature signal"                                                                               annotation (Placement(
        transformation(
        origin={0,-90},
        extent={{10,-10},{-10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
equation
  // Relative temperature
  T_rel = Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))) -
          Medium.temperature(Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow)));
  annotation (
    Icon(graphics={
        Line(points={{0,40},{0,28}},   color={0,0,127}),
        Text(
          extent={{-12,64},{-130,34}},
          lineColor={0,0,0},
          textString="T_rel"),
          Text(extent={{-60,-50},{60,-22}}, textString=DynamicSelect("0.0",
              String(y, format="1." + String(precision) + "f"))),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
The relative temperature \"T(port_a) - T(port_b)\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end RelativeTemperature;
