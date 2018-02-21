within TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U;
function lambda_T

  import TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK.from_btu_hrfeetF;

  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=from_btu_hrfeetF(0.75);
end lambda_T;
