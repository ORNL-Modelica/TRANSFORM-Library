within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency;
model Constant "Constant efficiency"
  extends TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.PartialEfficiencyChar;
   parameter SI.Efficiency eta_constant = 1.0 "Constant efficiency" annotation(Dialog);
algorithm
  eta := eta_constant;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant;
