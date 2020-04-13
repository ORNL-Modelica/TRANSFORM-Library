within TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water;
function cp_T
  // Note: linear fit from 15 - 300 C, not over full range of source data
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp :=(7.3219e-4*(T-273.15) + 0.81485)*4180;
end cp_T;
