within TRANSFORM.Media.Fluids.KFZrF4.Utilities;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=0.0005*T - 0.032;
end lambda_T;
