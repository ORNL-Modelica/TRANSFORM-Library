within TRANSFORM.Media.Fluids.KFZrF4.Utilities;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=-0.887*T+3658;
end d_T;
