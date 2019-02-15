within TRANSFORM.HeatAndMassTransfer.Sensors;
model Temperature "Ideal sensor for temperature"
   extends BaseClasses.PartialAbsoluteSensor;
   extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=T,
       redeclare replaceable function iconUnit =
         TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC
       constrainedby
      TRANSFORM.Units.Conversions.Functions.Temperature_K.BaseClasses.to);
   Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Temperature in port" annotation (Placement(transformation(
           extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{
             120,10}})));
equation
   T = port.T;
  annotation (
    Documentation(info="<html>
<p>This is an ideal absolute temperature sensor which returns the temperature of the connected port in Kelvin as an output signal.</p>
<p>The sensor itself has no thermal interaction with whatever it is connected to.  </p>
<p>Furthermore, no thermocouple-like lags are associated with this sensor model.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={191,0,0}),
        Text(
          extent={{150,44},{30,14}},
          lineColor={0,0,0},
          textString="T")}));
end Temperature;
