within TRANSFORM.Media.Fluids.NaClMgCl2_Eutectic.Utilities;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.from_cal_gK(0.258);
end cp_T;
