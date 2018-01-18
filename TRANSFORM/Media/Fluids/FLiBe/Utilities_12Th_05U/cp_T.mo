within TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U;
function cp_T
  import TRANSFORM.Units.Conversions.Functions.SpecificHeatCapacity_J_kgK.from_btu_lbF;

  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=from_btu_lbF(0.32);
end cp_T;
