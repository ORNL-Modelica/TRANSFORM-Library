within TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U;
function d_T

  import TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degF;
  import TRANSFORM.Units.Conversions.Functions.Density_kg_m3.from_lb_feet3;

  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:= from_lb_feet3(236.3-0.0233*to_degF(T));
end d_T;
