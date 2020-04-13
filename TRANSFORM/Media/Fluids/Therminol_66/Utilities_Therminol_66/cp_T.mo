within TRANSFORM.Media.Fluids.Therminol_66.Utilities_Therminol_66;
function cp_T
  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp :=1e3*(0.003313*(T-273.15) + 0.0000008970785*(T-273.15)^2 + 1.496005);
end cp_T;
