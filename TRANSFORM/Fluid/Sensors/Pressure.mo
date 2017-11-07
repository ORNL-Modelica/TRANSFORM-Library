within TRANSFORM.Fluid.Sensors;
model Pressure "Ideal pressure sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=p,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_Pa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  p = port.p;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255}),
        Text(
          extent={{137,50},{43,20}},
          lineColor={0,0,0},
          textString="p")}), Documentation(info="<html>
<p>
This component monitors the absolute pressure at its fluid port. The sensor is
ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end Pressure;
