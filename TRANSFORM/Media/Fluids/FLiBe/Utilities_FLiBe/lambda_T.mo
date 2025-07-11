within TRANSFORM.Media.Fluids.FLiBe.Utilities_FLiBe;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  // ORNL/TM-2006/12 Eq 6 with Table 8 values put in. See below.
  // lambda := 0.0005*T + 32.0/33.0 - 0.34;
  // Also matches: https://www.researchgate.net/publication/287324762
  lambda:=0.0005*T + 0.63;
end lambda_T;
