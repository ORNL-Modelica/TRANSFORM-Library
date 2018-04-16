within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction.Functions.Examples;
model Volume_wSlipRatio_noSlip
  extends TRANSFORM.Icons.Example;

  constant Integer n = 10 "Number of data points";
  constant SI.Density rho_lsat = 887.1064 "Saturated liquid density at 10 bar";
  constant SI.Density rho_vsat = 5.1454 "Saturated vapor density at 10 bar";
  constant SI.QualityFactor[n] x_abs = linspace(0.0,1.0,n) "Mass quality of interest";

  Units.VoidFraction[n] alphaV "Void fraction";
equation
  for i in 1:n loop
    alphaV[i] =alphaV_Homogeneous_wSlipRatio(
      x_abs[i],
      rho_lsat,
      rho_vsat);
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=1));
end Volume_wSlipRatio_noSlip;
