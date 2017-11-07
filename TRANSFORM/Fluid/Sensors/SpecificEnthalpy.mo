within TRANSFORM.Fluid.Sensors;
model SpecificEnthalpy "Ideal one port specific enthalpy sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=h_out,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.to_J_kg
      constrainedby
      TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
      final unit="J/kg") "Specific enthalpy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  h_out = inStream(port.h_outflow);
  annotation (
    defaultComponentName="specificEnthalpy",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{148,44},{32,14}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255})}),
    Documentation(info="<html>
<p>
This component monitors the specific enthalpy of the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEnthalpy;
