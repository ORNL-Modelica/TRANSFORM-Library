within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.BaseClasses;
expandable connector SignalSubBus_ActuatorInput
  extends TRANSFORM.Examples.Interfaces.SignalSubBus_ActuatorInput;
  Real reactivity_ControlRod "Control Rod Drive Mechanism Reactivity";
  SI.Power Q_flow_liquidHeater "Pressurizer heater in the liquid phase";
  SI.MassFlowRate SGpump_m_flow "Flow rate in SG recirculation";
  SI.MassFlowRate FWpump_m_flow "Feed water flow rate";
  annotation (defaultComponentName="actuatorBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalSubBus_ActuatorInput;
