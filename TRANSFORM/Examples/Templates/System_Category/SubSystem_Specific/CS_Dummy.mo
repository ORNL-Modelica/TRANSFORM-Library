within TRANSFORM.Examples.Templates.System_Category.SubSystem_Specific;
model CS_Dummy
  extends BaseClasses.Partial_ControlSystem;
annotation(defaultComponentName="changeMe_CS", Icon(graphics={
        Text(
          extent={{-94,82},{94,74}},
          textColor={0,0,0},
          textString="Change Me")}));
end CS_Dummy;
