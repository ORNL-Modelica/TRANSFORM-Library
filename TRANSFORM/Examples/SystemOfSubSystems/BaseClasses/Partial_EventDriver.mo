within TRANSFORM.Examples.SystemOfSubSystems.BaseClasses;
partial model Partial_EventDriver

  extends Examples.BaseClasses.Partial_EventDriver;

  SignalBus_ActuatorInput actuatorBus
    annotation (Placement(transformation(extent={{10,-120},{50,-80}}),
        iconTransformation(extent={{10,-120},{50,-80}})));
  SignalBus_SensorOutput sensorBus
    annotation (Placement(transformation(extent={{-50,-120},{-10,-80}}),
        iconTransformation(extent={{-50,-120},{-10,-80}})));

  annotation (defaultComponentName = "ED",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Partial_EventDriver;
