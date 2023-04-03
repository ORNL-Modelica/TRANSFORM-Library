within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Power;
model Constant "Constant power consumption"
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Power.PartialPowerChar;
   parameter SI.Power W_constant = 0.0 "Constant power consumption" annotation(Dialog);
algorithm
  W := W_constant;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant;
