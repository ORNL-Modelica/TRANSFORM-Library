within TRANSFORM.Media.Fluids.Therminol_66.Utilities_Therminol_66;
function d_T
  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d :=-0.614254*(T-273.15) - 0.000321*(T-273.15)^2.0 + 1020.62;
end d_T;
