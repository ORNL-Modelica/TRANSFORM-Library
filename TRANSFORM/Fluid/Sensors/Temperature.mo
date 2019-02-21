within TRANSFORM.Fluid.Sensors;
model Temperature "Ideal one port temperature sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=T,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Temperature_K.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Temperature in port medium" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{50,-10},{70,
            10}})));
equation
  T = Medium.temperature(Medium.setState_phX(
    port.p,
    inStream(port.h_outflow),
    inStream(port.Xi_outflow)));
  annotation (defaultComponentName="sensor_T",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-30,14},{-110,-16}},
          lineColor={0,0,0},
          textString="T"),
        Line(points={{0,-26},{0,-100}}, color={0,127,255})}),
                             Documentation(info="<html>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end Temperature;
