within TRANSFORM.Media.Fluids.NaK.Utilities_22_78;
function lambda_T

  import from_btu_hrfeetF =
    TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK.from_btu_hrftdegF;

  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=15.0006 + 30.2877e-3*T-20.8095e-6*T^2;
end lambda_T;
