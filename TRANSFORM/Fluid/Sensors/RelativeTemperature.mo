within TRANSFORM.Fluid.Sensors;
model RelativeTemperature "Ideal relative temperature sensor"
  extends BaseClasses.PartialRelativeSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=T_rel,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK.to_degC_diff
      constrainedby
      TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput T_rel(final quantity="ThermodynamicTemperature",
                                              final unit = "K", displayUnit = "degC", min=0)
    "Relative temperature signal"                                                                               annotation (Placement(
        transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,36})));

  parameter Boolean refPort_a = true "=true for T_rel = port_a.T - port_b.T else T_rel = port_b.T - port_a.T";

equation
  // Relative temperature
  if refPort_a then
    T_rel = Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))) -
            Medium.temperature(Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow)));
  else
    T_rel = Medium.temperature(Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow))) -
            Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
  end if;

  annotation (
    Icon(graphics={
        Text(
          extent={{110,62},{-8,32}},
          lineColor={0,0,0},
          textString="T_rel"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
The relative temperature \"T(port_a) - T(port_b)\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end RelativeTemperature;
