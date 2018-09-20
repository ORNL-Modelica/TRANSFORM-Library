within TRANSFORM.Fluid.Sensors;
model Density "Ideal one port density sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=d,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Density_kg_m3.to_kg_m3
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Density_kg_m3.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput d(final quantity="Density",
                                          final unit="kg/m3",
                                          min=0) "Density in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));

equation
  d = Medium.density(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));
  annotation (defaultComponentName="sensor_d",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-30,14},{-110,-16}},
          lineColor={0,0,0},
          textString="d"),
        Line(points={{0,-26},{0,-100}}, color={0,127,255})}),
                             Documentation(info="<html>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end Density;
