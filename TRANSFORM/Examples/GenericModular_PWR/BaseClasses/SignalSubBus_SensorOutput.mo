within TRANSFORM.Examples.GenericModular_PWR.BaseClasses;
expandable connector SignalSubBus_SensorOutput
  extends TRANSFORM.Examples.Interfaces.SignalSubBus_SensorOutput;
  SI.Power Q_total;
  SI.TemperatureDifference dT_core;
  annotation (defaultComponentName="sensorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalSubBus_SensorOutput;
