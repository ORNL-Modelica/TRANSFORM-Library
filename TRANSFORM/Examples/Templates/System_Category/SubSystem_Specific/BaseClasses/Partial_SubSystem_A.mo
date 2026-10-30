within TRANSFORM.Examples.Templates.System_Category.SubSystem_Specific.BaseClasses;
partial model Partial_SubSystem_A
  extends Partial_SubSystem;
  extends Record_SubSystem_A;
  annotation (
    defaultComponentName="changeMe",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            140}})));
end Partial_SubSystem_A;
