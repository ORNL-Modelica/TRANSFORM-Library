within TRANSFORM.Fluid.Sensors;
model SpecificEntropy "Ideal one port specific entropy sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=s,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.to_J_kgK
      constrainedby
      TRANSFORM.Units.Conversions.Functions.SpecificEntropy_J_kgK.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)")
    "Specific entropy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));
equation
  s = Medium.specificEntropy(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));
  annotation (defaultComponentName="sensor_s",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{0,-26},{0,-100}}, color={0,127,255}),
        Text(
          extent={{-30,14},{-110,-16}},
          lineColor={0,0,0},
          textString="s")}), Documentation(info="<html>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEntropy;
