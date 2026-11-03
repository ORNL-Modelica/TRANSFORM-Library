within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency;
partial model PartialEfficiencyChar
  "Base class for pump efficiency characteristics."
  extends PartialCharacteristic;
  SI.Efficiency eta "Efficiency";
equation
  affinityLaw = 1.0;
  annotation (defaultComponentName="flowCurve",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          textColor={0,0,0},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialEfficiencyChar;
