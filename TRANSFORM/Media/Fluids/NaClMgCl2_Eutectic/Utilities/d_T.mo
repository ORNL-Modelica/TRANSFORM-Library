within TRANSFORM.Media.Fluids.NaClMgCl2_Eutectic.Utilities;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:= (2.2971 - 0.000507*(T-273.15))*1000;
end d_T;
