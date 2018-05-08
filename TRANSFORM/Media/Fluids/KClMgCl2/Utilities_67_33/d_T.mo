within TRANSFORM.Media.Fluids.KClMgCl2.Utilities_67_33;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  d:=2000.7-0.45709*T;
end d_T;
