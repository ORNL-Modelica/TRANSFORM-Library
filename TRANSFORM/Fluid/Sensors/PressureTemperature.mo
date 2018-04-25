within TRANSFORM.Fluid.Sensors;
model PressureTemperature "Ideal pressure and temperature sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialRotationIcon_withValueIndicator_2values(final var=p,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_Pa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to,
      final var2=T,
      redeclare replaceable function iconUnit2 =
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Temperature_K.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Temperature in port medium" annotation (Placement(transformation(
          extent={{-100,-10},{-120,10}}),
                                        iconTransformation(extent={{-100,-10},{-120,
            10}})));

equation
  p = port.p;

  T = Medium.temperature(Medium.setState_phX(
    port.p,
    inStream(port.h_outflow),
    inStream(port.Xi_outflow)));

  annotation (defaultComponentName="sensor_pT",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{0,-70},{0,-100}}, color={0,127,255}),
        Text(
          extent={{137,50},{43,20}},
          lineColor={0,0,0},
          textString="p"),
        Text(
          extent={{-30,44},{-150,14}},
          lineColor={0,0,0},
          textString="T")}), Documentation(info="<html>
<p>
This component monitors the absolute pressure at its fluid port. The sensor is
ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end PressureTemperature;
