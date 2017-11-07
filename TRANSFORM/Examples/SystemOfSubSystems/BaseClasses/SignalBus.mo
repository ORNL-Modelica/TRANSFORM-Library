within TRANSFORM.Examples.SystemOfSubSystems.BaseClasses;
expandable connector SignalBus "Data bus for all specific busses"

  extends Examples.Interfaces.SignalBus;

  SignalBus_ActuatorInput actuatorBus
    "Signal bus for actuator/input signals";
  SignalBus_SensorOutput sensorBus
    "Signal bus for sensor/output signals";

  annotation (defaultComponentName="signalBus");
end SignalBus;
