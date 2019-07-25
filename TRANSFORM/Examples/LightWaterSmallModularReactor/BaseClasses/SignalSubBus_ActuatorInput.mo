within TRANSFORM.Examples.LightWaterSmallModularReactor.BaseClasses;
expandable connector SignalSubBus_ActuatorInput
  extends TRANSFORM.Examples.Interfaces.SignalSubBus_ActuatorInput;
  Real reactivity_ControlRod "Control Rod Drive Mechanism Reactivity";
  Real reactivity_Other "Additional Uncategorized Reactivity";
  SI.Power Q_S_External "External source of power to the Reactor";
  SI.Conversions.NonSIunits.AngularVelocity_rpm speedPump "Rotational speed of coolant pumps";
  SI.Power Q_flow_liquidHeater "Pressurizer heater in the liquid phase";
  annotation (defaultComponentName="actuatorBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalSubBus_ActuatorInput;
