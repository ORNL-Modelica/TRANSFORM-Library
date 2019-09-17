within TRANSFORM.Media.Fluids.FLiBe.Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:= (2.575-5.13e-4*(T-273.15))*1000;
end d_T;
