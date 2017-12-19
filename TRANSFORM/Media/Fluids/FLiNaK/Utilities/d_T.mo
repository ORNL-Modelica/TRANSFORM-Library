within TRANSFORM.Media.Fluids.FLiNaK.Utilities;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=-0.73*T+2729;
end d_T;
