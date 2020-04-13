within TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water;
function d_T
  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d :=-0.002435*(T-273.15)^2.0 - 0.338484*(T-273.15) + 1082.287;
end d_T;
