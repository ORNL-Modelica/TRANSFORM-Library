within TRANSFORM.Examples.Templates.System_Standalone.Data;
record Data_Dummy
  extends BaseClasses.Record_Data;
  annotation (
    defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="changeMe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end Data_Dummy;
