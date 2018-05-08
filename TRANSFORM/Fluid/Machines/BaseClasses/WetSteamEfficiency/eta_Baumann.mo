within TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency;
model eta_Baumann "Baumann rule"
  extends TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.Partial_eta;

  parameter SI.Efficiency alpha = 1.0 "Baumann factor";

equation
  eta = eta_nominal*(1-alpha*(1-0.5*(x_abs_in+x_abs_out)));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Leyzerovich, A. &apos;Wet-steam Turbines for Nuclear Power Plants,&apos; pg. 69, 2005.</p>
</html>"));
end eta_Baumann;
