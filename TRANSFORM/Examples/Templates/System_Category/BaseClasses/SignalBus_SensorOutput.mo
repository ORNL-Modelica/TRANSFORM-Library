within TRANSFORM.Examples.Templates.System_Category.BaseClasses;
expandable connector SignalBus_SensorOutput
  extends Examples.Interfaces.SignalBus_SensorOutput;
  System_Category.SubSystem_Specific.BaseClasses.SignalSubBus_SensorOutput subSystem_Specific;
  annotation (defaultComponentName="sensorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalBus_SensorOutput;
