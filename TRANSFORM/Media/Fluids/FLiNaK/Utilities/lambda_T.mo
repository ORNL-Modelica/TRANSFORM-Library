within TRANSFORM.Media.Fluids.FLiNaK.Utilities;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=0.0005*T + 0.43;
end lambda_T;
