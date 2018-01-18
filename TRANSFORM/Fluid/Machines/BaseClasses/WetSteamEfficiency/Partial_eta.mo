within TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency;
partial model Partial_eta

 input Units.NonDim x_abs_in "Inlet quality";
 input Units.NonDim x_abs_out "Outlet quality";

  parameter SI.Efficiency eta_nominal = 0.85 "Nominal efficiency due to wetness";
  SI.Efficiency eta "Turbine efficiency due to wetness";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Partial_eta;
