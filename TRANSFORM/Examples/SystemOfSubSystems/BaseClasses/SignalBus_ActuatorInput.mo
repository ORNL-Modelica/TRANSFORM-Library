within TRANSFORM.Examples.SystemOfSubSystems.BaseClasses;
expandable connector SignalBus_ActuatorInput
  import TRANSFORM;
  extends Examples.Interfaces.SignalBus_ActuatorInput;
  TRANSFORM.Examples.SystemOfSubSystems.PHS.BaseClasses.SignalSubBus_ActuatorInput
    PHS;
  annotation (defaultComponentName="actuatorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalBus_ActuatorInput;
