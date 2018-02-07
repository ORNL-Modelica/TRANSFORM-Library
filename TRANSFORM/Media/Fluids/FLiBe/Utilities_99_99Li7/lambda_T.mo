within TRANSFORM.Media.Fluids.FLiBe.Utilities_99_99Li7;
function lambda_T

  import
    TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK.from_btu_hrfeetF;

  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=from_btu_hrfeetF(0.58);
end lambda_T;
