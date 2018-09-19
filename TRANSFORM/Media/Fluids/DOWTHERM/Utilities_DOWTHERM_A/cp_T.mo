within TRANSFORM.Media.Fluids.DOWTHERM.Utilities_DOWTHERM_A;
function cp_T

  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;

algorithm
  cp := 2.79813*T + 7.54676e2;

end cp_T;
