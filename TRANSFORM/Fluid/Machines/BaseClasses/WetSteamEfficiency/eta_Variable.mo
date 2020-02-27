within TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency;
model eta_Variable "Simple transient access to eta"
  extends TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.Partial_eta;
  input SI.Efficiency alpha = 1.0 "Scaling factor for eta_nominal" annotation(Dialog(group="Inputs"));
equation
  eta = eta_nominal*alpha;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Leyzerovich, A. &apos;Wet-steam Turbines for Nuclear Power Plants,&apos; pg. 69, 2005.</p>
</html>"));
end eta_Variable;
