within TRANSFORM.Media.Fluids.Sodium.Utilities;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=-0.24093*T+1.0196e3;
end d_T;
