within TRANSFORM.Examples.Templates.System_Category.SubSystem_Specific;
model ED_Dummy
  extends BaseClasses.Partial_EventDriver;
annotation(defaultComponentName="changeMe_CS", Icon(graphics={
        Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Change Me")}));
end ED_Dummy;
