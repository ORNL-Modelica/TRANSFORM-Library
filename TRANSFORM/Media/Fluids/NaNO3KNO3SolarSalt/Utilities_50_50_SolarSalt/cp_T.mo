within TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt.Utilities_50_50_SolarSalt;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=1396.044+0.172*T;
end cp_T;
