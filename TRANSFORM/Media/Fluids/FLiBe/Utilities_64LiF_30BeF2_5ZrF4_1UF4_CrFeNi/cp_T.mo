within TRANSFORM.Media.Fluids.FLiBe.Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
function cp_T
  import TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.from_cal_gK;
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=from_cal_gK(0.57);
end cp_T;
