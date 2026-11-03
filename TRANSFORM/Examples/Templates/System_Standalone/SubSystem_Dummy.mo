within TRANSFORM.Examples.Templates.System_Standalone;
model SubSystem_Dummy
  extends BaseClasses.Partial_SubSystem(
    redeclare replaceable CS_Dummy CS,
    redeclare replaceable ED_Dummy ED,
    redeclare Data.Data_Dummy data);
  annotation (
    defaultComponentName="changeMe",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-94,82},{94,74}},
          textColor={0,0,0},
          textString="Change Me")}));
end SubSystem_Dummy;
