within TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency;
model eta_Constant "Constant efficiency"
  extends TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.Partial_eta;

equation
  eta = eta_nominal;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end eta_Constant;
