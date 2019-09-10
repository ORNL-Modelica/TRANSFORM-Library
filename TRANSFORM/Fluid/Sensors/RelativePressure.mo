within TRANSFORM.Fluid.Sensors;
model RelativePressure "Ideal relative pressure sensor"
  extends BaseClasses.PartialRelativeSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=p_rel,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_Pa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput p_rel(final quantity="Pressure",
                                              final unit="Pa",
                                              displayUnit="bar")
    "Relative pressure signal" annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,36})));
equation
  // Relative pressure
  p_rel = port_a.p - port_b.p;
  annotation (
    Icon(graphics={
        Text(
          extent={{114,62},{-12,32}},
          lineColor={0,0,0},
          textString="p_rel"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255}),
        Polygon(
          points={{4,0},{-4,-4},{-4,4},{4,0}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-36,18},
          rotation=360),
        Line(points={{-70,18},{-40,18}})}),
    Documentation(info="<html>
<p>
The relative pressure \"port_a.p - port_b.p\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end RelativePressure;
