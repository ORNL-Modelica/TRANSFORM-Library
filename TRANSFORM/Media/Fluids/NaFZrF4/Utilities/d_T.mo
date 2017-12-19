within TRANSFORM.Media.Fluids.NaFZrF4.Utilities;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=-0.889*T+3827;
end d_T;
