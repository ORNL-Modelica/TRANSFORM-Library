within TRANSFORM.Media.Fluids.FLiBe.Utilities_57_33_9995Li7;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=-0.4884*T+2413;
end d_T;
