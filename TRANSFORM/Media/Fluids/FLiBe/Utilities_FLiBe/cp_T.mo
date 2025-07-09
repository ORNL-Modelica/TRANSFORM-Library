within TRANSFORM.Media.Fluids.FLiBe.Utilities_FLiBe;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  // ORNL/TM-2006/12 Derived from Table A. Table 7 gives 2414 and is probably more accurate and switched.
  cp:=2416;
end cp_T;
