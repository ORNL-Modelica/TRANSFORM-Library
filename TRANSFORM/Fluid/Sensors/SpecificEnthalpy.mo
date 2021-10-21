within TRANSFORM.Fluid.Sensors;
model SpecificEnthalpy "Ideal one port specific enthalpy sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=h_out,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.to_J_kg
      constrainedby TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
      final unit="J/kg") "Specific enthalpy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));
equation
  h_out = inStream(port.h_outflow);
  annotation (defaultComponentName="sensor_h",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-30,14},{-110,-16}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{0,-26},{0,-100}}, color={0,127,255})}),
                             Documentation(info="<html>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEnthalpy;
