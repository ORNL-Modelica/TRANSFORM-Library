within TRANSFORM.Media.Fluids.NaK.Utilities_22_78;
function cp_T
  import from_btu_lbF =
    TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.from_btu_lbdegF;
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=3.884e-4*T^2 - 0.60967*T+1109.9;
end cp_T;
