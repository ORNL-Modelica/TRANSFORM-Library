within TRANSFORM.Examples.GenericModular_PWR.BaseClasses;
expandable connector SignalSubBus_ActuatorInput

  extends TRANSFORM.Examples.Interfaces.SignalSubBus_ActuatorInput;

  Real reactivity_CR;
  SI.MassFlowRate m_flow_steam;

  annotation (defaultComponentName="actuatorSubBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalSubBus_ActuatorInput;
