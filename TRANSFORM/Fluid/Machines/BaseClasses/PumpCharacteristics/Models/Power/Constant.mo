within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Power;
model Constant "Constant power consumption"
  extends PartialPowerChar;

   parameter SI.Power W_constant = 0.0 "Constant power consumption" annotation(Dialog);

equation
  W =  W_constant;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant;
