within TRANSFORM.Media.Fluids.NaK.Utilities_22_78;
function d_T

  import TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degF;
  import TRANSFORM.Units.Conversions.Functions.Density_kg_m3.from_lb_feet3;

  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:= 933.68 - 0.2424*T;
end d_T;
