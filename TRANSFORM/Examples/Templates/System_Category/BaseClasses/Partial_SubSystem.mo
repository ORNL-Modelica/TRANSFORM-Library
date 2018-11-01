within TRANSFORM.Examples.Templates.System_Category.BaseClasses;
partial model Partial_SubSystem

  extends Examples.BaseClasses.Partial_SubSystem;
  extends Record_SubSystem;

  replaceable Partial_ControlSystem CS annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-18,122},{-2,138}})));
  replaceable Partial_EventDriver ED annotation (choicesAllMatching=true,
      Placement(transformation(extent={{2,122},{18,138}})));

  SignalBus_ActuatorInput actuatorBus
    annotation (Placement(transformation(extent={{10,80},{50,120}}),
        iconTransformation(extent={{10,80},{50,120}})));
  SignalBus_SensorOutput sensorBus
    annotation (Placement(transformation(extent={{-50,80},{-10,120}}),
        iconTransformation(extent={{-50,80},{-10,120}})));

equation
  connect(sensorBus, ED.sensorBus) annotation (Line(
      points={{-30,100},{-16,100},{7.6,100},{7.6,122}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus, CS.sensorBus) annotation (Line(
      points={{-30,100},{-12.4,100},{-12.4,122}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus, CS.actuatorBus) annotation (Line(
      points={{30,100},{12,100},{-7.6,100},{-7.6,122}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus, ED.actuatorBus) annotation (Line(
      points={{30,100},{20,100},{12.4,100},{12.4,122}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));

  annotation (
    defaultComponentName="changeMe",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-94,-76},{94,-84}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Change Me")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})));
end Partial_SubSystem;
