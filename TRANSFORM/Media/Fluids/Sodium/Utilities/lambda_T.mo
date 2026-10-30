within TRANSFORM.Media.Fluids.Sodium.Utilities;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=-0.043096*T + 99.3504;
end lambda_T;
