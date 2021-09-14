within TRANSFORM.Fluid.Sensors;
model PressureTemperature "Ideal pressure and temperature sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_2values(                    final var=p,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_MPa
      constrainedby TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to,
      final var2=T,
      redeclare replaceable function iconUnit2 =
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC
      constrainedby TRANSFORM.Units.Conversions.Functions.Temperature_K.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{50,14},{70,34}})));
  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Temperature in port medium" annotation (Placement(transformation(
          extent={{100,-30},{120,-10}}),iconTransformation(extent={{50,-32},{70,
            -12}})));
equation
  p = port.p;
  T = Medium.temperature(Medium.setState_phX(
    port.p,
    inStream(port.h_outflow),
    inStream(port.Xi_outflow)));
  annotation (defaultComponentName="sensor_pT",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{0,-50},{0,-100}}, color={0,127,255}),
        Text(
          extent={{-30,-10},{-110,-40}},
          lineColor={0,0,0},
          textString="T"),
        Text(
          extent={{-30,40},{-110,10}},
          lineColor={0,0,0},
          textString="p")}), Documentation(info="<html>
<p>
This component monitors the absolute pressure at its fluid port. The sensor is
ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end PressureTemperature;
