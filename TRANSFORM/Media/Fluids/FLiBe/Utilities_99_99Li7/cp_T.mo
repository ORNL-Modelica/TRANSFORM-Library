within TRANSFORM.Media.Fluids.FLiBe.Utilities_99_99Li7;
function cp_T
  import from_btu_lbF =
    TRANSFORM.Units.Conversions.Functions.SpecificHeatCapacity_J_kgK.from_btu_lbdegF;

  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=from_btu_lbF(0.57);
end cp_T;
