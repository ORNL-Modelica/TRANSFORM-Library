within TRANSFORM.Examples.Templates.System_Category.SubSystem_Specific.BaseClasses;
partial model Partial_SubSystem
  extends System_Category.BaseClasses.Partial_SubSystem(
      redeclare replaceable BaseClasses.Partial_ControlSystem CS constrainedby BaseClasses.Partial_ControlSystem,
                                         redeclare replaceable
      BaseClasses.Partial_EventDriver ED constrainedby BaseClasses.Partial_EventDriver);
  replaceable Record_Data data
    annotation (Placement(transformation(extent={{42,122},{58,138}})));
  extends Record_SubSystem;
  annotation (
    defaultComponentName="changeMe",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})));
end Partial_SubSystem;
