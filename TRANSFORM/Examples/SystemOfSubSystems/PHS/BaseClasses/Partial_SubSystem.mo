within TRANSFORM.Examples.SystemOfSubSystems.PHS.BaseClasses;
partial model Partial_SubSystem
  import TRANSFORM;
  extends TRANSFORM.Examples.SystemOfSubSystems.BaseClasses.Partial_SubSystem(
      redeclare replaceable BaseClasses.Partial_ControlSystem CS
      constrainedby BaseClasses.Partial_ControlSystem, redeclare replaceable
                  BaseClasses.Partial_EventDriver ED constrainedby
      BaseClasses.Partial_EventDriver);
  replaceable Record_Data data
    annotation (Placement(transformation(extent={{42,122},{58,138}})));
  extends Record_SubSystem;
  annotation (
    defaultComponentName="PHS",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-94,-76},{94,-84}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Primary Heat System")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})));
end Partial_SubSystem;
