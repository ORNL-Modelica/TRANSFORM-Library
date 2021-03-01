within TRANSFORM.Fluid.Sensors;
model Pressure "Ideal pressure sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=p,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_MPa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));
equation
  p = port.p;
  annotation (defaultComponentName="sensor_p",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-30,14},{-110,-16}},
          lineColor={0,0,0},
          textString="p"),
        Line(points={{0,-26},{0,-100}}, color={0,127,255})}),
                             Documentation(info="<html>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end Pressure;
