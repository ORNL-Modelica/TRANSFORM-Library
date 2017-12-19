within TRANSFORM.Media.Fluids.Sodium.Utilities;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=7.4338e-3*T+1.287e3;
end cp_T;
