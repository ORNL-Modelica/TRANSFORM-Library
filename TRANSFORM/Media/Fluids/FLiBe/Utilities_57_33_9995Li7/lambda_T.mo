within TRANSFORM.Media.Fluids.FLiBe.Utilities_57_33_9995Li7;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=0.0005*T + 0.63;
end lambda_T;
