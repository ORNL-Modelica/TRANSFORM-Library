within TRANSFORM.Examples.SystemOfSubSystems.BaseClasses;
expandable connector SignalBus_SensorOutput
  import TRANSFORM;

  extends Examples.Interfaces.SignalBus_SensorOutput;

  TRANSFORM.Examples.SystemOfSubSystems.PHS.BaseClasses.SignalSubBus_SensorOutput
    PHS;

  annotation (defaultComponentName="sensorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalBus_SensorOutput;
