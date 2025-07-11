within TRANSFORM.Media.Fluids.FLiBe.Utilities_FLiBe;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  // ORNL/TM-2006/12 Derived from Table A. Table 7 gives 2414 and is probably more accurate and switched.
  // Also matches: https://www.researchgate.net/publication/287324762
  cp:=2416;
end cp_T;
