within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.from_cal_gK(0.24);
end cp_T;
