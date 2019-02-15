within TRANSFORM.Examples.Templates.System_Category.BaseClasses;
expandable connector SignalBus_ActuatorInput
  extends Examples.Interfaces.SignalBus_ActuatorInput;
  System_Category.SubSystem_Specific.BaseClasses.SignalSubBus_ActuatorInput subSystem_Specific;
  annotation (defaultComponentName="actuatorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalBus_ActuatorInput;
