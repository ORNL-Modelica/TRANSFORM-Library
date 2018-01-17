within TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U;
function cp_T
  import TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK.from_btuhrftf;
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  cp:=from_btuhrftf(0.75);
end cp_T;
