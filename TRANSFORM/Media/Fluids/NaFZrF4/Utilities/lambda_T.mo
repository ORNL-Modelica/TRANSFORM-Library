within TRANSFORM.Media.Fluids.NaFZrF4.Utilities;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=0.0005*T + 0.0052;
end lambda_T;
