within TRANSFORM.Fluid.Sensors;
model SpecificEntropy "Ideal one port specific entropy sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=s,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificEntropy_J_kgK.to_J_kgK
      constrainedby
      TRANSFORM.Units.Conversions.Functions.SpecificEntropy_J_kgK.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)")
    "Specific entropy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  s = Medium.specificEntropy(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));
annotation (defaultComponentName="specificEntropy",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{142,46},{40,16}},
          lineColor={0,0,0},
          textString="s"),
Text(extent={{-60,-50},{60,-22}}, textString=DynamicSelect("0.0",
              String(y, format="1." + String(precision) + "f"))),
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255})}),
  Documentation(info="<html>
<p>
This component monitors the specific entropy of the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEntropy;
