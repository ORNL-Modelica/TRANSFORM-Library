within TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency;
model eta_Variable "Simple transient access to eta"
  extends TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.Partial_eta;
  input SI.Efficiency alpha = 1.0 "Scaling factor for eta_nominal" annotation(Dialog(group="Inputs"));
equation
  eta = eta_nominal*alpha;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end eta_Variable;
