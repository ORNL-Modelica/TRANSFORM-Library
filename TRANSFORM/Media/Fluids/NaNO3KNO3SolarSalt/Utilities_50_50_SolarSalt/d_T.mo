within TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt.Utilities_50_50_SolarSalt;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:= 2263.628 - 0.636*(T);
end d_T;
