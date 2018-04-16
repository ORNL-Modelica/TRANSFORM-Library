within TRANSFORM.Fluid.Sensors;
model RelativePressure "Ideal relative pressure sensor"
  extends BaseClasses.PartialRelativeSensor;
  extends BaseClasses.PartialRelativeIcon_withValueIndicator(final var=p_rel,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_Pa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput p_rel(final quantity="Pressure",
                                              final unit="Pa",
                                              displayUnit="bar")
    "Relative pressure signal" annotation (Placement(transformation(
        origin={0,-90},
        extent={{10,-10},{-10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
equation

  // Relative pressure
  p_rel = port_a.p - port_b.p;
  annotation (
    Icon(graphics={
        Line(points={{0,40},{0,28}},   color={0,0,127}),
        Text(
          extent={{-6,66},{-132,36}},
          lineColor={0,0,0},
          textString="p_rel"),
          Text(extent={{-60,-50},{60,-22}}, textString=DynamicSelect("0.0",
              String(y, format="1." + String(precision) + "f"))),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
The relative pressure \"port_a.p - port_b.p\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end RelativePressure;
