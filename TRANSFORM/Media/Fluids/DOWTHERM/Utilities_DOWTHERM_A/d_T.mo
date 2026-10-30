within TRANSFORM.Media.Fluids.DOWTHERM.Utilities_DOWTHERM_A;
function d_T
  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d := -8.91977e-1*T + 1.32610e03;
end d_T;
